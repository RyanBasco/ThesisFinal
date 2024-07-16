import 'package:flutter/material.dart';
import 'package:testing/TouristDashboard/GenerateQR.dart';
import 'package:testing/TouristDashboard/QrPage.dart';


class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) { // Check if "Trip Plan" option is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegistrationPage()), // Navigate to RegistrationPage
      );
    } else if (index == 3) { // Check if "Itinerary" option is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QRPage()), // Navigate to ItineraryPage
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xFFDEE77A),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFFDEE77A),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color(0xFF2C812A),
          unselectedItemColor: Color(0xFF2C812A),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feed),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trip_origin),
              label: 'Trip Plan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Itinerary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Navigate back
          },
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '< Back',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
