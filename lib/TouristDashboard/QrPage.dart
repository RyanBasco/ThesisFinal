import 'package:flutter/material.dart';
import 'package:testing/TouristDashboard/GenerateQR.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';

class QRPage extends StatefulWidget {
  const QRPage({super.key});

  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  int _selectedIndex = 1;

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
      body: Container(
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
                        Navigator.pop(context); // Navigate back to the previous page
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'QR Reader',
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
              const SizedBox(height: 20),
              Center(
                child: _buildThirdInfoContainer(), // Center the "Generate QR" container
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThirdInfoContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GenerateQR()), // Navigate to GenerateQR page
        );
      },
      child: Container(
        height: 250,
        width: 280,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9), // Curved edges
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 7), // Shadow offset
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Generate.png', // Replace with your image asset path for Generate QR
              width: 150, // Adjust size as needed
              height: 150,
            ),
            const SizedBox(height: 10),
            const Text(
              'Generate QR',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),      
          ],      
        ),
      ),
    );
  }
}
