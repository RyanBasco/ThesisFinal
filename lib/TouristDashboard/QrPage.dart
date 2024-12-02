import 'package:flutter/material.dart';
import 'package:testing/Authentication/FormsRegistration.dart';
import 'package:testing/Authentication/TouristSignupcontinue.dart';
import 'package:testing/Groups/Groups.dart';
import 'package:testing/TouristDashboard/GenerateQR.dart';
import 'package:testing/TouristDashboard/Purposeoftravel.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';

class QRPage extends StatefulWidget {
  const QRPage({super.key});

  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  int _selectedIndex = 2;

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

  // Navigate to the new page without animation (direct transition)
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
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
              const Padding(
                padding:
                     EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                child: Row(
                  children: [
                     SizedBox(width: 10),
                     Expanded(
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
                child: Column(
                  children: [
                    _buildQRInfoContainer(), // First container for "Generate QR"
                    const SizedBox(height: 20), // Space between containers
                    _buildPurposeInfoContainer(), // Second container for "Purpose of Travel"
                    const SizedBox(height: 20), // Space between containers
                    _buildTravelRegistrationBox(), // New container for "Travel Registration"
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Container for "Generate QR"
  Widget _buildQRInfoContainer() {
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

  // Container for "Purpose of Travel"
  Widget _buildPurposeInfoContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Purposeoftravel()), // Navigate to Purposeoftravel page
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
            const Icon(
              Icons.travel_explore, // Icon for "Purpose of Travel"
              size: 130,
              color: Color(0xFF288F13),
            ),
            const SizedBox(height: 25),
            const Text(
              'Purpose of Travel',
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

  // Container for "Travel Registration"
  Widget _buildTravelRegistrationBox() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignupContinue()), // Navigate to TravelRegistrationPage
        );
      },
      child: Container(
        height: 120,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.assignment, // Icon for "Travel Registration"
              size: 60,
              color: Color(0xFF288F13),
            ),
            const SizedBox(width: 15),
            const Text(
              'Travel Registration',
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
