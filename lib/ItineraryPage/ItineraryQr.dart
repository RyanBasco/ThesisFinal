import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:testing/ItineraryPage/Itinerary.dart';
import 'package:testing/TouristDashboard/Registration.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class ItineraryQrPage extends StatefulWidget {
  final Map<String, dynamic> itineraryData;

  ItineraryQrPage({required this.itineraryData});

  @override
  _ItineraryQrPageState createState() => _ItineraryQrPageState();
}

class _ItineraryQrPageState extends State<ItineraryQrPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
  if (index == 0) { // Check if "Home" option is tapped
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserdashboardPageState()), // Navigate to UserDashboard
    );
  } else if (index == 2) { // Check if "Registration" option is tapped
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()), // Navigate to RegisterAsIndividualPage
    );
  } else if (index == 3) { // Check if "Itinerary" option is tapped
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItineraryPage()), // Navigate to ItineraryPage
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
      appBar: PreferredSize( 
        preferredSize: Size.fromHeight(150.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: Color(0xFFDEE77A),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Image.asset(
                            'assets/guimarasvist.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Builder(
                          builder: (context) => IconButton(
                            icon: Icon(Icons.menu, color: Colors.black),
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            Container(
              color: Color(0xFFDEE77A),
              padding: EdgeInsets.only(top: 40.0, bottom: 23, left: 27.0, right: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0), // Adjust this value to move the circle avatar
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: AssetImage('lib/assets/Vector.png'), // Replace with your image asset
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Juan Dela Cruz',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // You can add more items to the drawer here
          ],
        ),
      ),
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
              icon: Icon(Icons.app_registration),
              label: 'Registration',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF114F3A),
                    ),
                    child: Icon(Icons.chevron_left, color: Colors.white),
                  ),
                ),
                SizedBox(width: 8.0),
                // Text removed here
              ],
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 60.0), // Added padding to move text to the right
              child: Text(
                'Expense Validation QR Code',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.0),
            // White box with itinerary data and QR code
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Generate QR code
                  Center(
                    child: RepaintBoundary(
                      child: QrImageView(
                        data: widget.itineraryData.toString(), // Convert data to string for QR code
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Display itinerary data
                  Text(
                    '${widget.itineraryData['Name'] ?? ''}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '${widget.itineraryData['Address'] ?? ''}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '${widget.itineraryData['Date'] ?? ''}',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
