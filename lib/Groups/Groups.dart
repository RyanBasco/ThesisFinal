import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

enum SpendingMode { Individual, Group }

class _GroupPageState extends State<GroupPage> {
  final _database =
      FirebaseDatabase.instance.ref(); // Firebase Database reference
  int _selectedIndex = 1; // Default selected tab index for Groups
  SpendingMode _spendingMode = SpendingMode.Individual; // Default spending mode
  final List<String> _myGroups = []; // Example group list
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  String? _selectedGroup;
  String? _selectedCategory; // Holds the selected category
  bool _showQRCodeButton = false;
  String? _groupId;

  List<Map<String, dynamic>> _users =
      []; // List of all users fetched from Firebase
  List<String> _selectedUserIds = []; // List of selected user document IDs

  bool _isLoading = false; // Add this state variable

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    if (_myGroups.isNotEmpty) {
      _selectedGroup = _myGroups.first; // Set default group
    }
  }

  Future<void> _fetchUsers() async {
    try {
      final snapshot = await _database.child('Users').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final users = data.entries.map((entry) {
          final userData = Map<String, dynamic>.from(entry.value);
          return {
            "docId": entry.key,
            "first_name": userData["first_name"],
            "last_name": userData["last_name"],
          };
        }).toList();
        setState(() {
          _users = users;
        });
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  void _showQRCodeDialog(String groupId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ensures the dialog size fits content
              children: [
                Text(
                  _spendingMode == SpendingMode.Group
                      ? 'Group QR Code'
                      : 'Individual QR Code',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                groupId.isNotEmpty
                    ? QrImageView(
                        data: _spendingMode == SpendingMode.Group
                            ? groupId
                            : "Category: ${_categoryController.text}, Amount: ${_amountController.text}",
                        version: QrVersions.auto,
                        size: 150.0, // QR code size
                      )
                    : Center(child: Text('No QR code available')),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onModeChange(SpendingMode? mode) {
    if (mode == null) return;
    setState(() {
      _spendingMode = mode;
      _selectedGroup = null;
      _selectedUserIds.clear();
    });
  }

  Future<void> _saveGroupTransaction(String category, double amount) async {
    setState(() => _isLoading = true); // Show loading indicator
    final groupId = _database
        .child('GroupSpendings')
        .push()
        .key!
        .replaceAll("-", ""); // Fixed the issue with the dash in groupID
    final transaction = {
      "groupID": groupId,
      "members": _selectedUserIds,
      "category": category,
      "amount": amount,
      "timestamp": DateFormat('hh:mm a').format(DateTime.now()), // Only time
    };

    try {
      // Save the transaction to Firebase
      await _database
          .child('GroupSpendings')
          .child(groupId)
          .set(transaction); // Fixed saving without dash
      setState(() => _isLoading = false); // Hide loading indicator

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Group transaction saved successfully!"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the success dialog

                  // Show the appropriate QR Code dialog
                  if (_spendingMode == SpendingMode.Group) {
                    _showQRCodeDialog(
                        groupId); // Pass the groupId for Group QR Code generation
                  } else {
                    _generateIndividualQR(); // For Individual mode, generate individual QR code
                  }

                  // Set the QR Code button to visible after the dialog is closed
                  setState(() {
                    _showQRCodeButton = true; // Show the View QR Code button
                  });
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() => _isLoading = false); // Hide loading indicator
      print("Error saving transaction: $e");
    }
  }

  void _addMembersDialog() {
    String searchQuery = ""; // Search query
    List<Map<String, dynamic>> filteredUsers = _users;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            // Use dialogSetState for updates inside dialog
            return AlertDialog(
              title: Column(
                children: [
                  Text('Add Members'),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      dialogSetState(() {
                        searchQuery = query.toLowerCase();
                        filteredUsers = _users.where((user) {
                          final name =
                              "${user['first_name']} ${user['last_name']}"
                                  .toLowerCase();
                          return name.contains(searchQuery);
                        }).toList();
                      });
                    },
                  ),
                ],
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Column(
                    children: filteredUsers.map((user) {
                      return CheckboxListTile(
                        title:
                            Text("${user['first_name']} ${user['last_name']}"),
                        value: _selectedUserIds.contains(user["docId"]),
                        onChanged: (bool? value) {
                          dialogSetState(() {
                            if (value == true) {
                              _selectedUserIds.add(user["docId"]);
                            } else {
                              _selectedUserIds.remove(user["docId"]);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {}); // Trigger UI rebuild on the parent
                    Navigator.of(context).pop();
                  },
                  child: Text("Done"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _createGroup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _groupNameController,
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_groupNameController.text.isNotEmpty) {
                    // Create a new group entry in Firebase
                    final newGroupRef = _database.child('Groups').push();
                    await newGroupRef.set({
                      'name': _groupNameController.text,
                      'createdAt': ServerValue.timestamp,
                    });

                    setState(() {
                      _myGroups.add(_groupNameController.text);
                      _groupNameController.clear();
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Create'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2C812A),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _viewQR(String data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("QR Code"),
          content: Column(
            children: [
              // Use a package like 'qr_flutter' to generate the actual QR code
              Text("Generated QR: $data"),
              // Actual QR code will be displayed here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _generateGroupQR() {
    // Logic to generate QR for the group, including members and transaction info
    String groupData = "Group: $_selectedGroup, Members: $_selectedUserIds";
    _generateQR(groupData);
  }

  void _generateIndividualQR() {
    // Logic to generate QR for individual transactions
    String individualData =
        "Category: ${_categoryController.text}, Amount: ${_amountController.text}";
    _showQRCodeDialog(individualData);
  }

  void _generateQR(String data) {
    // QR code generation logic (you can use a package like 'qr_flutter' to generate the QR)
    // Example:
    // QRCode data is passed to a QR widget, showing the QR code
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("QR Code"),
          content: Column(
            children: [
              // Here, you'd display the QR code based on the data
              Text("Generated QR: $data"),
              // Use qr_flutter or any similar package to display the actual QR code
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget page;

    switch (index) {
      case 0:
        page = UserdashboardPageState();
        break;
      case 1:
        page = GroupPage();
        break;
      case 2:
        page = QRPage();
        break;
      case 3:
        page = RegistrationPage();
        break;
      case 4:
        page = TouristprofilePage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _deleteGroup(String groupName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Group'),
          content: Text('Are you sure you want to delete "$groupName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _myGroups.remove(groupName);
                  if (_selectedGroup == groupName) {
                    _selectedGroup = _myGroups.isNotEmpty ? _myGroups.first : null;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _renameGroup(String oldName) {
    final TextEditingController renameController = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename Group'),
          content: TextField(
            controller: renameController,
            decoration: InputDecoration(
              labelText: 'New Group Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (renameController.text.isNotEmpty) {
                  try {
                    // Update in Firebase
                    final snapshot = await _database.child('Groups').get();
                    if (snapshot.exists) {
                      final data = Map<String, dynamic>.from(snapshot.value as Map);
                      String? groupKey;
                      data.forEach((key, value) {
                        if (value is Map && value['name'] == oldName) {
                          groupKey = key;
                        }
                      });
                      
                      if (groupKey != null) {
                        await _database.child('Groups').child(groupKey!).update({
                          'name': renameController.text,
                        });
                        
                        setState(() {
                          int index = _myGroups.indexOf(oldName);
                          if (index != -1) {
                            _myGroups[index] = renameController.text;
                            _selectedGroup = renameController.text;
                          }
                        });
                      }
                    }
                  } catch (e) {
                    print("Error renaming group: $e");
                  }
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2C812A),
              ),
              child: Text('Rename', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          // Get the full height of the screen using MediaQuery
          height: MediaQuery.of(context)
              .size
              .height, // This ensures the container always fills the screen height
          padding: const EdgeInsets.only(bottom: 20.0),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const Padding(
                padding: EdgeInsets.only(top: 50.0, bottom: 20.0),
                child: Center(
                  child: Text(
                    'Groups',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // Create Group Button
              if (_spendingMode == SpendingMode.Group) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: _createGroup,
                      child: Text(
                        'Create Group',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2C812A),
                      ),
                    ),
                  ),
                ),
              ],
              // Spending Mode Toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mode Selector
                    Row(
                      children: [
                        Text("Mode: "),
                        DropdownButton<SpendingMode>(
                          value: _spendingMode,
                          onChanged: _onModeChange,
                          items: SpendingMode.values.map((SpendingMode mode) {
                            return DropdownMenuItem(
                              value: mode,
                              child: Text(mode == SpendingMode.Individual
                                  ? 'Individual'
                                  : 'Group'),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    // Group Selection Dropdown with Label
                    if (_spendingMode == SpendingMode.Group) ...[
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text("Group Name:",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(width: 10),
                                Container(
                                  width: 150,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    value: _selectedGroup,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedGroup = newValue;
                                        _selectedUserIds.clear();
                                      });
                                    },
                                    items: _myGroups.map((String group) {
                                      return DropdownMenuItem(
                                        value: group,
                                        child: Text(
                                          group,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                if (_selectedGroup != null) ...[
                                  SizedBox(width: 5),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Color(0xFF2C812A)),
                                    onPressed: () => _renameGroup(_selectedGroup!),
                                    constraints: BoxConstraints(minWidth: 40),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteGroup(_selectedGroup!),
                                    constraints: BoxConstraints(minWidth: 40),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Add Members Button
                    if (_spendingMode == SpendingMode.Group &&
                        _selectedGroup != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ElevatedButton(
                          onPressed: _addMembersDialog,
                          child: Text("Add Members",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2C812A),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            textStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    // Display Selected Members
                    if (_spendingMode == SpendingMode.Group &&
                        _selectedGroup != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Selected Members:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: _selectedUserIds.map((userId) {
                              final user = _users
                                  .firstWhere((u) => u['docId'] == userId);
                              return Chip(
                                label: Text(
                                  "${user['first_name']} ${user['last_name']}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                                onDeleted: () {
                                  setState(() {
                                    _selectedUserIds.remove(userId);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              // Transaction Form
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // New Category Dropdown
                      Row(
                        children: [
                          Text(
                            "Category:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedCategory,
                              hint: Text("Select a category"),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                              },
                              items: <String>[
                                'Accommodation',
                                'Food',
                                'Services'
                              ].map((String category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Existing Amount Field
                      Row(
                        children: [
                          Text(
                            "Amount:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              decoration: InputDecoration(
                                hintText: 'Enter amount',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Container(
                          width: 200, // Fixed width
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2C812A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: _isLoading
                                ? null
                                : () {
                                    if (_amountController.text.isNotEmpty &&
                                        _selectedCategory != null) {
                                      final category =
                                          _selectedCategory!; // Safely unwrap the category value
                                      final amount = double.tryParse(
                                              _amountController.text) ??
                                          0;
                                      _saveGroupTransaction(category, amount);

                                      setState(() {
                                        // Show the "View QR Code" button after saving the transaction
                                        _showQRCodeButton = true;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Please select a category and enter an amount.')),
                                      );
                                    }
                                  },
                            child: Text(
                              'Save Group Transaction',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // View QR Code Button
                      if (_showQRCodeButton) ...[
                        Center(
                          child: Container(
                            width: 200, // Fixed width
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2C812A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () {
                                _showQRCodeDialog(
                                    _groupId ?? "default-group-id");
                              },
                              child: Text(
                                'View QR Code',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]
                    ]),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF27AE60),
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Groups',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
