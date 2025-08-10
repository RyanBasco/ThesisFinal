import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/Groups/Travel.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

enum ViewType {
  Visits,
  Groups,
}

// Add this class to store group details
class GroupDetails {
  final String groupName;
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> expenses;

  GroupDetails({
    required this.groupName,
    required this.users,
    required this.expenses,
  });
}

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedIndex = 3; // Changed from 1 to 3 since this is now History tab
  List<Map<String, dynamic>> visits = [];
  ViewType _selectedView = ViewType.Visits;
  List<GroupDetails> userGroups = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchVisits();
  }

  Future<void> _fetchVisits() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference ref = FirebaseDatabase.instance.ref().child('Visits');
        DatabaseEvent event = await ref.once();

        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> visitsData =
              event.snapshot.value as Map<dynamic, dynamic>;
          List<Map<String, dynamic>> tempVisits = [];
          // Map to track visits count and last visit date for each establishment per month
          Map<String, Map<String, dynamic>> establishmentMonthlyVisits = {};

          visitsData.forEach((key, value) {
            if (value is Map) {
              Map<dynamic, dynamic> establishment =
                  value['Establishment'] ?? {};

              String establishmentName =
                  establishment['establishmentName'] ?? '';
              String dateStr = value['Date'] ?? '';
              String timeStr = value['Time'] ?? '';

              List<String> dateParts = dateStr.split('/');
              if (dateParts.length == 3) {
                DateTime visitDate = DateTime(
                  int.parse(dateParts[2]), // year
                  int.parse(dateParts[0]), // month
                  int.parse(dateParts[1]), // day
                );

                // Create a key for the establishment and month
                String monthKey =
                    '${establishmentName}_${visitDate.year}_${visitDate.month}';

                bool shouldInclude = true;

                if (establishmentMonthlyVisits.containsKey(monthKey)) {
                  var monthData = establishmentMonthlyVisits[monthKey]!;
                  int visitCount = monthData['count'] as int;
                  DateTime lastVisit = monthData['lastVisit'] as DateTime;

                  // Check if we already have 2 visits this month
                  if (visitCount >= 2) {
                    shouldInclude = false;
                  } else {
                    // Check for 3-day gap
                    int daysDifference =
                        visitDate.difference(lastVisit).inDays.abs();
                    shouldInclude = daysDifference >= 3;
                  }
                }

                if (shouldInclude) {
                  // Update or create the monthly visit data
                  establishmentMonthlyVisits[monthKey] = {
                    'count':
                        (establishmentMonthlyVisits[monthKey]?['count'] ?? 0) +
                            1,
                    'lastVisit': visitDate,
                  };

                  tempVisits.add({
                    'establishmentName': establishmentName,
                    'date': dateStr,
                    'time': timeStr,
                    'establishmentID': establishment['EstablishmentID'] ?? '',
                  });
                }
              }
            }
          });

          tempVisits.sort((a, b) {
            List<String> datePartsA = a['date'].toString().split('/');
            List<String> datePartsB = b['date'].toString().split('/');

            DateTime dateA = DateTime(
              int.parse(datePartsA[2]), // year
              int.parse(datePartsA[0]), // month
              int.parse(datePartsA[1]), // day
            );
            DateTime dateB = DateTime(
              int.parse(datePartsB[2]), // year
              int.parse(datePartsB[0]), // month
              int.parse(datePartsB[1]), // day
            );

            int dateComparison = dateB.compareTo(dateA);
            if (dateComparison != 0) return dateComparison;

            return b['time'].toString().compareTo(a['time'].toString());
          });

          setState(() {
            visits = tempVisits;
          });
        }
      }
    } catch (e) {
      print('Error fetching visits: $e');
    }
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

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                'History',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Dropdown Container
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                        ),
                        child: DropdownButtonFormField<ViewType>(
                          value: _selectedView,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Color(0xFF27AE60),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          items: ViewType.values.map((ViewType type) {
                            return DropdownMenuItem<ViewType>(
                              value: type,
                              child: Text(_formatViewType(type)),
                            );
                          }).toList(),
                          onChanged: (ViewType? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedView = newValue;
                              });
                              if (newValue == ViewType.Groups) {
                                fetchGroupData();
                              }
                            }
                          },
                        ),
                      ),
                      // Content based on selected view
                      Expanded(
                        child: _buildSelectedView(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFF51F643),
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 65,
        index: _selectedIndex,
        animationDuration: const Duration(milliseconds: 333000),
        animationCurve: Curves.easeInOut,
        items: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home,
                  size: 24,
                  color: _selectedIndex == 0
                      ? const Color(0xFF27AE60)
                      : Colors.grey),
              Text('Home',
                  style: TextStyle(
                      color: _selectedIndex == 0
                          ? const Color(0xFF27AE60)
                          : Colors.grey,
                      fontSize: 10),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.travel_explore,
                  size: 24,
                  color: _selectedIndex == 1
                      ? const Color(0xFF27AE60)
                      : Colors.grey),
              Text('Travel',
                  style: TextStyle(
                      color: _selectedIndex == 1
                          ? const Color(0xFF27AE60)
                          : Colors.grey,
                      fontSize: 10),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.attach_money,
                  size: 24,
                  color: _selectedIndex == 2
                      ? const Color(0xFF27AE60)
                      : Colors.grey),
              Text('Transaction',
                  style: TextStyle(
                      color: _selectedIndex == 2
                          ? const Color(0xFF27AE60)
                          : Colors.grey,
                      fontSize: 10),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history,
                  size: 24,
                  color: _selectedIndex == 3
                      ? const Color(0xFF27AE60)
                      : Colors.grey),
              Text('History',
                  style: TextStyle(
                      color: _selectedIndex == 3
                          ? const Color(0xFF27AE60)
                          : Colors.grey,
                      fontSize: 10),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person,
                  size: 24,
                  color: _selectedIndex == 4
                      ? const Color(0xFF27AE60)
                      : Colors.grey),
              Text('Profile',
                  style: TextStyle(
                      color: _selectedIndex == 4
                          ? const Color(0xFF27AE60)
                          : Colors.grey,
                      fontSize: 10),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSelectedView() {
    switch (_selectedView) {
      case ViewType.Visits:
        return visits.isEmpty
            ? const Center(
                child: Text(
                  'No visit history found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: visits.length,
                itemBuilder: (context, index) {
                  final visit = visits[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.store,
                          color: const Color(0xFF27AE60),
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                visit['establishmentName'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${visit['date']} at ${_formatTime(visit['time'])}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
      case ViewType.Groups:
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : userGroups.isEmpty
                ? const Center(
                    child: Text(
                      'No groups found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: userGroups.length,
                    itemBuilder: (context, index) {
                      final group = userGroups[index];
                      return ExpansionTile(
                        leading: const Icon(
                          Icons.group,
                          color: Color(0xFF27AE60),
                          size: 24,
                        ),
                        title: Text(
                          group.groupName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          // Display members
                          ...group.users.map((user) => ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(
                                    '${user['first_name']} ${user['last_name']}'),
                              )),
                          // Display expenses
                          ...group.expenses.map((expense) {
                            IconData iconData = _getCategoryIcon(
                                expense['Category'] ?? 'default');
                            return ListTile(
                              leading: Icon(iconData),
                              title: Text(
                                  expense['Category'] ?? 'Unknown Category'),
                              subtitle: Text(
                                  '${expense['Date']} at ${_formatTime(expense['Time'])}'),
                              trailing: Text(
                                '₱${expense['TotalSpend']}',
                                style: const TextStyle(
                                  color: Color(0xFF27AE60),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  );
      default:
        return const Center(
            child: Text('Invalid view type')); // Handle unmatched cases
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'accommodation':
        return Icons.hotel;
      case 'food':
        return Icons.restaurant;
      case 'transportation':
        return Icons.directions_car;
      case 'entertainment':
        return Icons.movie;
      default:
        return Icons.receipt;
    }
  }

  String _formatTime(String time) {
    try {
      // Parse the 24-hour format time
      List<String> parts = time.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);

      // Convert to 12-hour format
      String period = hours >= 12 ? 'PM' : 'AM';
      hours = hours > 12 ? hours - 12 : hours;
      hours = hours == 0 ? 12 : hours; // Convert 0 to 12 for midnight

      // Format the time with leading zeros for minutes
      return '$hours:${minutes.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time; // Return original time if parsing fails
    }
  }

  Future<void> _createGroup(
      String groupName, List<Map<String, dynamic>> selectedUsers) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final DatabaseReference database = FirebaseDatabase.instance.ref();

      // Get the logged-in user's details from the 'Forms' node
      DatabaseEvent userEvent =
          await database.child('Forms').child(currentUser.uid).once();
      final userData = userEvent.snapshot.value as Map<dynamic, dynamic>?;

      if (userData == null) {
        print("Logged-in user's details not found.");
        return;
      }

      // Create a new group reference
      final newGroupRef = database.child('Groups').push();

      // Prepare the group data
      final Map<String, dynamic> groupData = {
        'User 1': {
          'uid': currentUser.uid,
          'first_name': userData['first_name'],
          'last_name': userData['last_name'],
        },
        'groupName': groupName,
        'UID': currentUser.uid, // Document ID of the logged-in user
      };

      // Add selected users to the group
      int userIndex = 2;
      for (var user in selectedUsers) {
        DatabaseEvent userEvent =
            await database.child('Forms').child(user['uid']).once();
        final selectedUserData =
            userEvent.snapshot.value as Map<dynamic, dynamic>?;

        if (selectedUserData != null) {
          groupData['User $userIndex'] = {
            'uid': user['uid'],
            'first_name': selectedUserData['first_name'],
            'last_name': selectedUserData['last_name'],
          };
          userIndex++;
        }
      }

      // Save the group data to the database
      await newGroupRef.set(groupData);
      print('Group created successfully with ID: ${newGroupRef.key}');
    } catch (e) {
      print('Error creating group: $e');
    }
  }

  // Add this method to fetch group data
  Future<void> fetchGroupData() async {
    setState(() => isLoading = true);
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final DatabaseReference database = FirebaseDatabase.instance.ref();

      // Fetch groups where user is a member
      DatabaseEvent groupsEvent = await database.child('Groups').once();
      if (groupsEvent.snapshot.value == null) return;

      Map<dynamic, dynamic> groupsData =
          groupsEvent.snapshot.value as Map<dynamic, dynamic>;
      List<GroupDetails> tempGroups = [];

      for (var groupEntry in groupsData.entries) {
        Map<dynamic, dynamic> groupData =
            groupEntry.value as Map<dynamic, dynamic>;

        // Check if user is a member of this group
        bool isMember = false;
        List<Map<String, dynamic>> groupUsers = [];

        groupData.forEach((key, value) {
          if (key.toString().startsWith('User') && value is Map) {
            if (value['uid'] == currentUser.uid) {
              isMember = true;
            }
            groupUsers.add({
              'uid': value['uid'],
              'first_name': value['first_name'],
              'last_name': value['last_name'],
            });
          }
        });

        if (isMember) {
          // Fetch visits for this group based on GroupID and UID
          List<Map<String, dynamic>> groupExpenses = [];
          DatabaseEvent visitsEvent = await database
              .child('Visits')
              .orderByChild('GroupID')
              .equalTo(groupEntry.key) // Match GroupID with document ID
              .once();

          if (visitsEvent.snapshot.value != null) {
            Map<dynamic, dynamic> visitsData =
                visitsEvent.snapshot.value as Map<dynamic, dynamic>;

            visitsData.forEach((key, value) {
              if (value is Map && value['UID'] == currentUser.uid) {
                groupExpenses.add({
                  'TotalSpend': value['TotalSpend'] ?? 0,
                  'Date': value['Date'] ?? '',
                  'Time': value['Time'] ?? '',
                });
              }
            });
          }

          tempGroups.add(GroupDetails(
            groupName: groupData['groupName'] ?? 'Unnamed Group',
            users: groupUsers,
            expenses: groupExpenses, // Include fetched expenses
          ));
        }
      }

      setState(() {
        userGroups = tempGroups;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching group data: $e');
      setState(() => isLoading = false);
    }
  }

  // Add this helper method to format the enum values
  String _formatViewType(ViewType type) {
    switch (type) {
      case ViewType.Visits:
        return 'Visits';
      case ViewType.Groups:
        return 'Groups';
    }
  }
}
