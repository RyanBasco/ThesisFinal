import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class GenerateQR extends StatefulWidget {
  const GenerateQR({super.key});

  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  int _selectedIndex = 1;
  String qrData = '';
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  if (userEmail != null) {
    try {
      final ref = FirebaseDatabase.instance.ref().child('Users');
      final snapshot = await ref.get();

      if (snapshot.exists && snapshot.value != null) {
        for (var entry in (snapshot.value as Map).entries) {
          final Map<String, dynamic> user = Map<String, dynamic>.from(entry.value);
          String emailFromDatabase = user['email'] ?? '';

          if (emailFromDatabase.toLowerCase() == userEmail.toLowerCase()) {
            userData = user;
            String documentId = entry.key;

            setState(() {
              qrData = documentId;
            });
            return;
          }
        }
        print('User data not found for email: $userEmail');
      } else {
        print('No data found in Realtime Database');
      }
    } catch (error) {
      print('Failed to fetch user data: $error');
    }
  } else {
    print('User email is null');
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
          selectedItemColor: const Color(0xFF2C812A),
          unselectedItemColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'My QR',
            ),
            BottomNavigationBarItem(
               icon: Icon(Icons.attach_money),
               label: 'Expense Tracker',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
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
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.arrow_back, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Generate QR',
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
                  _buildWhiteContainer(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteContainer() {
    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    String firstName = userData!['first_name'] ?? '';
    String lastName = userData!['last_name'] ?? '';

    return Container(
      margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
      padding: const EdgeInsets.all(20),
      width: 280,
      height: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '$firstName $lastName',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
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
          MaterialPageRoute(builder: (context) => RegistrationPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TouristprofilePage()),
        );
        break;
    }
  }
}
