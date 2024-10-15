import 'package:flutter/material.dart';
import 'package:testing/EstablishmentDashboard/Establishmentdaily.dart';
import 'package:testing/EstablishmentDashboard/Establishmentdashboard.dart';
import 'package:testing/EstablishmentDashboard/Qrview.dart';
import 'package:testing/Wallet/Wallet.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';


class EstablishmentDailyPage extends StatefulWidget {
  const EstablishmentDailyPage({super.key});

  @override
  _EstablishmentDailyPageState createState() => _EstablishmentDailyPageState();
}

class _EstablishmentDailyPageState extends State<EstablishmentDailyPage> {
  final int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) { // Check if "Home" option is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EstablishmentDashboardPage()), // Navigate to UserDashboard
      );
    } else if (index == 2) { // Check if "Daily" option is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EstablishmentDashboardPage()), // Navigate to EstablishmentdailyPage
      );
    } else if (index == 3) { // Check if "Verify Spending" option is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EstablishmentDailyPage()), // Navigate to EstablishmentdailyPage
      );
    } else if (index == 4) { // Check if "Profile" option is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TouristprofilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: const Color(0xFFDEE77A),
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
                            'assets/establishment.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.black),
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
              color: const Color(0xFFDEE77A),
              padding: const EdgeInsets.only(top: 40.0, bottom: 23, left: 27.0, right: 50.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30.0), // Adjust this value to move the circle avatar
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: AssetImage('lib/assets/Vector.png'), // Replace with your image asset
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
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
          canvasColor: const Color(0xFFDEE77A),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFFDEE77A),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF2C812A),
          unselectedItemColor: const Color(0xFF2C812A),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist),
              label: 'Offering',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Daily',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Verify Spending',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Add a button to open the QR verification scanner
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRViewExample()),
                );
              },
              child: const Text('QR Verification Scanner'),
            ),
            // Replace the content with your registration form or any other content for this page
            const SizedBox(height: 20),
            // Add your registration form widgets or other content here
          ],
        ),
      ),
    );
  }
}
