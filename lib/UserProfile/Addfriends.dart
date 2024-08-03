import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/Wallet/Wallet.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart'; // Adjust the import path as necessary

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  int _selectedIndex = 3;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _usersCollection = FirebaseFirestore.instance.collection('Users');
  late String _currentUserEmail;
  List<DocumentSnapshot> _allUsers = [];
  List<DocumentSnapshot> _filteredUsers = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserEmail();
    _searchController.addListener(_filterUsers);
  }

  void _fetchCurrentUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserEmail = user.email!;
      });
      _fetchUsers();
    }
  }

  void _fetchUsers() async {
    QuerySnapshot snapshot = await _usersCollection.where('email', isNotEqualTo: _currentUserEmail).get();
    setState(() {
      _allUsers = snapshot.docs;
      _filteredUsers = _allUsers;
    });
  }

  void _filterUsers() {
  String query = _searchController.text.toLowerCase().trim();
  List<String> queryParts = query.split(' ');

  setState(() {
    _filteredUsers = _allUsers.where((user) {
      String firstName = (user['first_name'] ?? '').toLowerCase();
      String lastName = (user['last_name'] ?? '').toLowerCase();
      String email = (user['email'] ?? '').toLowerCase();

      bool matchesFirstName = queryParts.any((part) => firstName.contains(part));
      bool matchesLastName = queryParts.any((part) => lastName.contains(part));
      bool matchesEmail = email.contains(query);

      // Check if the query is contained within either first name, last name, or email
      return (queryParts.isEmpty ||
              (matchesFirstName || matchesLastName)) ||
             matchesEmail;
    }).toList();
  });
}



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserdashboardPageState()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TouristprofilePage()),
        );
        break;
    }
  }

  void _sendFriendRequest(String recipientEmail) async {
    QuerySnapshot senderSnapshot = await _usersCollection.where('email', isEqualTo: _currentUserEmail).get();

    if (senderSnapshot.docs.isNotEmpty) {
      var senderData = senderSnapshot.docs.first.data() as Map<String, dynamic>;
      String senderFirstName = senderData['first_name'] ?? 'First Name';
      String senderLastName = senderData['last_name'] ?? 'Last Name';

      CollectionReference requestsCollection = FirebaseFirestore.instance.collection('FriendRequests');

      await requestsCollection.add({
        'senderEmail': _currentUserEmail,
        'senderFirstName': senderFirstName,
        'senderLastName': senderLastName,
        'recipientEmail': recipientEmail,
        'status': 'pending',
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Friend request sent to $recipientEmail'),
        duration: Duration(seconds: 2),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User details not found. Unable to send friend request.'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  void _deleteUser(DocumentSnapshot user) {
    setState(() {
      _filteredUsers.remove(user);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('User removed from view.'),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
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
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 40, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black, size: 20),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Text(
                    'Add Friends',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 35), // This is to keep the title centered
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Oval shape with curved edges
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick Add',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _filteredUsers.isEmpty
                  ? Center(child: Text('No users found.'))
                  : ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        var user = _filteredUsers[index];
                        String firstName = user['first_name'] ?? 'First Name';
                        String lastName = user['last_name'] ?? 'Last Name';
                        String email = user['email'] ?? 'No Email';

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$firstName $lastName', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text(email, style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _sendFriendRequest(email);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xCC288F13), // 80% opacity color
                                      ),
                                      child: Text('Add Friend', style: TextStyle(color: Colors.white)), // Change text color to white
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        _deleteUser(user);
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
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
          selectedItemColor: Color(0xFF2C812A),
          unselectedItemColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'My QR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
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
