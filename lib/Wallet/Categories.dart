import 'package:flutter/material.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _selectedIndex = 2;

  // Define the list of categories with icons and colors
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Accommodation',
      'icon': Icons.hotel,
      'color': Colors.orangeAccent,
    },
    {
      'name': 'Food and Beverages',
      'icon': Icons.restaurant_menu,
      'color': Colors.redAccent,
    },
    {
      'name': 'Transportation',
      'icon': Icons.directions_car,
      'color': Colors.blueAccent,
    },
    {
      'name': 'Attractions and Activities',
      'icon': Icons.local_activity,
      'color': Colors.purpleAccent,
    },
    {
      'name': 'Shopping',
      'icon': Icons.shopping_bag,
      'color': Colors.greenAccent,
    },
    {
      'name': 'Entertainment',
      'icon': Icons.theater_comedy,
      'color': Colors.pinkAccent,
    },
    {
      'name': 'Wellness and Spa Services',
      'icon': Icons.spa,
      'color': Colors.teal,
    },
    {
      'name': 'Adventure and Outdoor Activities',
      'icon': Icons.terrain,
      'color': Colors.brown,
    },
    {
      'name': 'Travel Insurance',
      'icon': Icons.shield,
      'color': Colors.indigoAccent,
    },
    {
      'name': 'Local Tours and Guides',
      'icon': Icons.tour,
      'color': Colors.cyan,
    },
  ];

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
        break;
      case 2:
        break; // Current page
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
                        'Categories',
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ALL CATEGORIES',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF585858),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: categories.map((category) {
                  return Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFA7A7A7)),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CircleAvatar(
                            backgroundColor: category['color'],
                            child: Icon(category['icon'], color: Colors.white),
                          ),
                        ),
                        Text(
                          category['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            SizedBox( height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}
