import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:testing/Authentication/TouristLogin.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/Wallet/Wallet.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:testing/UserProfile/Addfriends.dart';
import 'package:testing/UserProfile/Changepassword.dart';
import 'package:testing/UserProfile/Editprofile.dart';
import 'package:testing/UserProfile/HelpCenter.dart';
import 'package:testing/UserProfile/Mybookmarks.dart';

class TouristprofilePage extends StatefulWidget {
  @override
  _TouristprofilePageState createState() => _TouristprofilePageState();
}

class _TouristprofilePageState extends State<TouristprofilePage> {
  String _firstName = '';
  String _lastName = '';
  String _userId = '';
  int _selectedIndex = 3; // Set initial index to 'Profile'

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _generateUserId();
  }

  void _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.size > 0) {
          var userData = querySnapshot.docs.first.data();
          setState(() {
            _firstName = userData['first_name'] ?? '';
            _lastName = userData['last_name'] ?? '';
          });
        } else {
          print('User data not found for email: ${user.email}');
        }
      } catch (error) {
        print('Failed to fetch user data: $error');
      }
    }
  }

  void _generateUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Generate a hash code from the user's email
    final emailHash = user.email?.hashCode ?? 0;

    // Map the hash code to a 4-digit number
    final userId = (emailHash.abs() % 9000 + 1000).toString();

    setState(() {
      _userId = userId;
    });
  }
}


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Handle "Home"
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserdashboardPageState()),
        );
        break;
      case 1:
        // Handle "My QR"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRPage()),
        );
        break;
      case 2:
        // Handle "Wallet"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage()),
        );
        break;
      // case 3: // No need to navigate to the same page (Profile)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.15, 0.54, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 300,
                  height: 650, // Increased height to accommodate new items
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 55,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10, // Adjusted to align with the profile icon
                        bottom: 490,
                        left: 70, // Adjust position to bottom right
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$_firstName $_lastName',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'User ID: $_userId',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 20,
                        bottom: 340,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfile()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2C812A),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 25),
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 92), // Add space between text and arrow
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 150,
                        left: 20,
                        bottom: 310,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2C812A),
                                ),
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 25),
                              Text(
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 40), // Add space between text and arrow
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 250,
                        left: 20,
                        bottom: 280,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FriendsPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2C812A),
                                ),
                                child: Icon(
                                  Icons.group_add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 25),
                              Text(
                                'Add Friends',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 85), // Add space between text and arrow
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 350,
                        left: 20,
                        bottom: 250,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BookmarkPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2C812A),
                                ),
                                child: Icon(
                                  Icons.bookmark,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 25),
                              Text(
                                'My Bookmarks',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 63), // Add space between text and arrow
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 400,
                        left: 20,
                        bottom: 170,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Helpcenter()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2C812A),
                                ),
                                child: Icon(
                                  Icons.help_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 25),
                              Text(
                                'Help Center',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 85), // Add space between text and arrow
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 490,
                        left: 20,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPageScreen()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 25),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 120), // Add space between text and arrow
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
