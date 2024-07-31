import 'package:flutter/material.dart';
import 'package:testing/Wallet/Wallet.dart';

class EstablishmentdailyPage extends StatefulWidget {
  @override
  _EstablishmentdailyPageState createState() => _EstablishmentdailyPageState();
}

class _EstablishmentdailyPageState extends State< EstablishmentdailyPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            // Replace the content with your registration form or any other content for this page
            SizedBox(height: 20),
            // Add your registration form widgets or other content here
          ],
        ),
      ),
    );
  }
}
