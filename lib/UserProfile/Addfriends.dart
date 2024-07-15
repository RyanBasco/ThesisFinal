import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/TouristDashboard/Registration.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart'; // Adjust the import path as necessary

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  int _selectedIndex = 3;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _usersCollection = FirebaseFirestore.instance.collection('Users');

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserdashboardPageState()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRPage()),
        );
        break; // Current page
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage()),
        );
        break;
      case 3:
        break;
    }
  }

  Future<void> _addFriend(String friendEmail) async {
    try {
      // Get current user's email (Assuming you have the user authenticated)
      String currentUserEmail = 'current_user_email'; // Replace with actual user email

      // Fetch user document based on email
      QuerySnapshot querySnapshot = await _usersCollection.where('email', isEqualTo: friendEmail).get();
      if (querySnapshot.docs.isNotEmpty) {
        String friendUserId = querySnapshot.docs.first.id;

        // Add friend to current user's friend list
        await _usersCollection.doc(currentUserEmail).update({
          'friends': FieldValue.arrayUnion([friendUserId]),
        });

        // Optionally, notify the user that friend was added successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User with email $friendEmail not found.')),
        );
      }
    } catch (error) {
      print('Error adding friend: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add friend. Please try again later.')),
      );
    }
  }

  Future<void> _removeFriend(String friendEmail) async {
    try {
      // Get current user's email (Assuming you have the user authenticated)
      String currentUserEmail = 'current_user_email'; // Replace with actual user email

      // Fetch user document based on email
      QuerySnapshot querySnapshot = await _usersCollection.where('email', isEqualTo: friendEmail).get();
      if (querySnapshot.docs.isNotEmpty) {
        String friendUserId = querySnapshot.docs.first.id;

        // Remove friend from current user's friend list
        await _usersCollection.doc(currentUserEmail).update({
          'friends': FieldValue.arrayRemove([friendUserId]),
        });

        // Optionally, notify the user that friend was removed successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend removed successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User with email $friendEmail not found.')),
        );
      }
    } catch (error) {
      print('Error removing friend: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove friend. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
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
        child: StreamBuilder(
          stream: _usersCollection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            List<DocumentSnapshot> users = snapshot.data?.docs ?? [];
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                String firstName = user['first_name'] ?? 'First Name';
                String lastName = user['last_name'] ?? 'Last Name';
                return ListTile(
                  title: Text('$firstName $lastName'),
                  subtitle: Text(user['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          _addFriend(user['email']); // Add user as a friend by email
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _removeFriend(user['email']); // Remove user from friends by email
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}