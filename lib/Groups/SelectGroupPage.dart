import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/Groups/History.dart';
import 'package:testing/Groups/Travel.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'GroupQRCodePage.dart';

class SelectGroupPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedUsers;

  const SelectGroupPage({Key? key, this.selectedUsers = const []}) : super(key: key);

  @override
  _SelectGroupPageState createState() => _SelectGroupPageState();
}

class _SelectGroupPageState extends State<SelectGroupPage> {
  final List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _selectedUsers = [];
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredUsers = [];
  bool _isLoading = false;
  final TextEditingController _groupNameController = TextEditingController();
  String _groupName = '';
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    _selectedUsers = List<Map<String, dynamic>>.from(widget.selectedUsers);
    _fetchUsersFromFirebase();
  }

  void _fetchUsersFromFirebase() {
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    database.child('Forms').once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _users.clear();
          data.forEach((key, value) {
            _users.add({
              'uid': key,
              'first_name': value['first_name'],
              'last_name': value['last_name'],
              'selected': false,
            });
          });
          print('Users fetched: $_users');
        });
      } else {
        print('No data found in Users node');
      }
    }).catchError((error) {
      print('Error fetching users: $error');
    });
  }

  void _showAddMembersDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Members'),
          content: const Text('Scan QR code to add a member'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showQRScannerDialog();
              },
              child: const Text('Scan QR'),
            ),
          ],
        );
      },
    );
  }

  void _showQRScannerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 350,
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 4,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Scan User QR Code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      
      // Process the scanned data (assuming it contains user ID)
      final userId = scanData.code;
      if (userId != null && userId.isNotEmpty) {
        Navigator.of(context).pop(); // Close the QR scanner dialog
        await _addUserFromQRCode(userId);
      } else {
        Navigator.of(context).pop(); // Close the QR scanner dialog
        _showWarningDialog('Invalid QR code');
      }
      
      controller.dispose();
    });
  }

  Future<void> _addUserFromQRCode(String userId) async {
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    
    try {
      final userSnapshot = await database.child('Forms').child(userId).once();
      final userData = userSnapshot.snapshot.value as Map<dynamic, dynamic>?;
      
      if (userData != null) {
        final newUser = {
          'uid': userId,
          'first_name': userData['first_name'],
          'last_name': userData['last_name'],
          'selected': true,
        };
        
        // Check if user is already in the selected list
        final isAlreadySelected = _selectedUsers.any((user) => user['uid'] == userId);
        
        if (!isAlreadySelected) {
          setState(() {
            _selectedUsers.add(newUser);
          });
          _showSuccessDialog('User added successfully!');
        } else {
          _showWarningDialog('This user is already in your group');
        }
      } else {
        _showWarningDialog('User not found');
      }
    } catch (error) {
      print('Error adding user: $error');
      _showWarningDialog('Failed to add user. Please try again.');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _confirmRemoveUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Member'),
          content: Text('Are you sure you want to remove ${user['first_name']} ${user['last_name']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedUsers.remove(user);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _createGroup() async {
    if (_selectedUsers.length < 1) {
      _showWarningDialog('You need to select at least 1 member to create a group.');
      return;
    }

    if (_groupName.isEmpty) {
      _showWarningDialog('Please enter a group name.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final DatabaseReference database = FirebaseDatabase.instance.ref();
    final currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser == null) {
      setState(() {
        _isLoading = false;
      });
      _showWarningDialog('No user is currently logged in.');
      return;
    }
    
    final Map<String, dynamic> groupData = {
        'groupName': _groupName,
        'UID': currentUser.uid,
        'creatorEmail': currentUser.email,
      };

      int userIndex = 1;
      for (var user in _selectedUsers) {
        final userId = user['uid'];
        final userSnapshot = await database.child('Forms').child(userId).once();
        final userDetails = userSnapshot.snapshot.value as Map<dynamic, dynamic>?;

        if (userDetails != null) {
          groupData['User $userIndex'] = {
            'uid': userId,
            'email': userDetails['email'],
            ...userDetails,
          };
          userIndex++;
        }
      }

      // Add the current user's details as well
      final currentUserSnapshot = await database.child('Forms').child(currentUser.uid).once();
      final currentUserDetails = currentUserSnapshot.snapshot.value as Map<dynamic, dynamic>?;
      
      if (currentUserDetails != null) {
        groupData['User 0'] = {
          'uid': currentUser.uid,
          ...currentUserDetails,
        };
      }

    try {
        // First, check if any groups exist with the same name
        final groupsSnapshot = await database.child('Groups').once();
        final groupsData = groupsSnapshot.snapshot.value as Map<dynamic, dynamic>?;

        if (groupsData != null) {
            bool groupNameExists = false;
            String existingGroupId = '';
            groupsData.forEach((key, value) {
                if (value['UID'] == currentUser.uid) {
                    groupNameExists = true;
                    existingGroupId = key; // Store the existing group ID
                }
            });

            if (groupNameExists) {
                // Overwrite the existing group
                await database.child('Groups').child(existingGroupId).set(groupData);
                setState(() {
                    _isLoading = false;
                });
                _showGroupCreatedDialog(existingGroupId);
                print('Group updated successfully with ID: $existingGroupId');
                return;
            }
        }

        // If no existing group found with the same UID, create a new group
        final newGroupRef = database.child('Groups').push();
        String groupId = newGroupRef.key!;
        await newGroupRef.set(groupData);
        setState(() {
            _isLoading = false;
        });
        _showGroupCreatedDialog(groupId);
        print('Group created successfully with ID: $groupId');
    } catch (error) {
        setState(() {
            _isLoading = false;
        });
        print('Error creating group: $error');
    }
  }

  void _showGroupCreatedDialog(String groupId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Group created successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GroupQRCodePage(groupId: groupId),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEEFFA9),
              Color(0xFFDBFF4C),
              Color(0xFF51F643),
            ],
            stops: [0.15, 0.54, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Navigate to the previous page
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xFF114F3A),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 60),
                      const Text(
                        'Select Group',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF114F3A),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _groupNameController,
                        decoration: const InputDecoration(
                          labelText: 'Group Name',
                          hintText: 'Enter group name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _groupName = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_groupName.isNotEmpty)
                        Text(
                          'Group Name: $_groupName',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF114F3A),
                          ),
                        ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      const Text(
                        'Selected Members:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF114F3A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_selectedUsers.isNotEmpty)
                        Column(
                          children: _selectedUsers.map((user) {
                            return ListTile(
                              title: Text(
                                '${user['first_name']} ${user['last_name']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF114F3A),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () {
                                  _confirmRemoveUser(user);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _showAddMembersDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF288F13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Add Members',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Center(
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createGroup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF288F13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Create Group',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xFF51F643),
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 65,
        index: 2, // Set to 1 for Groups tab
        animationDuration: Duration(milliseconds: 12200),
        animationCurve: Curves.easeInOut,
        items: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home, size: 24, color: Colors.grey),
              Text('Home', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.group, size: 24, color: Colors.grey),
              Text('Groups', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.attach_money, size: 24, color: Color(0xFF27AE60),),
              Text('Transaction', style: TextStyle(color: Color(0xFF27AE60), fontSize: 10)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 24, color: Colors.grey),
              Text('History', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person, size: 24, color: Colors.grey),
              Text('Profile', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ],
        onTap: (index) {
          Widget page;
          switch (index) {
            case 0:
              page = UserdashboardPageState();
              break;
            case 1:
              page = QRPage();
              break;
            case 2:
              page = RegistrationPage();
              break;
            case 3:
              page = HistoryPage();
              break;
            case 4:
              page = TouristprofilePage();
              break;
            default:
              return;
          }

          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => page,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return child;
              },
            ),
          );
        },
      ),
    );
  }
}