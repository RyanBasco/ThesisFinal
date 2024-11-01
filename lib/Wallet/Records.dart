import 'package:flutter/material.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  int _selectedIndex = 2;
  int _selectedTimeIndex = -1; // Track the selected time period

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
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TouristprofilePage()),
        );
        break;
    }
  }

  // Function to handle the selection of time period
  void _onTimePeriodSelected(int index) {
    setState(() {
      _selectedTimeIndex = index; // Update the selected index
    });
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
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
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
                              'Records',
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
                    Column(
                      children: [
                        // Container for the search bar
                        Container(
                          height: 110, // Adjust height as needed
                          width: MediaQuery.of(context).size.width, // Full width
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFA7A7A7)), // Border for the container
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                // Search bar
                                Container(
                                  height: 55, // Standard size for the search bar
                                  width: MediaQuery.of(context).size.width * 0.9, // Adjust width as needed
                                  decoration: BoxDecoration(
                                    color: Colors.grey[350], // Changed the inside color to grey[400]
                                    borderRadius: BorderRadius.circular(22), // Curved edges
                                    border: Border.all(color: Colors.black), // Black border around the search bar
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1), // Shadow effect
                                        blurRadius: 4,
                                        offset: const Offset(0, 2), // Shadow underneath the search bar
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Search...',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
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
                        const SizedBox(height: 0), // Space between search bar and categories
                        Column(
                          children: [
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: const Color(0xFFA7A7A7)),
                              ),
                              child: const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xFFFB0000),
                                      child: Icon(Icons.local_dining, color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    'Food & Drinks',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: const Color(0xFFA7A7A7)),
                              ),
                              child: const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xFF6FCBFF),
                                      child: Icon(Icons.card_giftcard, color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    'Souvenir Shop',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: const Color(0xFFA7A7A7)),
                              ),
                              child: const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xFFFFA51E),
                                      child: Icon(Icons.business, color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    'Accommodation',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Container for time period selection
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[400], // Background color
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Curved edges at the top
            ),
            padding: const EdgeInsets.all(8), // Padding for the container
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimePeriodOption('7 Days', 0),
                const VerticalDivider(color: Colors.black), // Divider line
                _buildTimePeriodOption('30 Days', 1),
                const VerticalDivider(color: Colors.black), // Divider line
                // Removed '12 Weeks' option
                const VerticalDivider(color: Colors.black), // Divider line
                _buildTimePeriodOption('6 Months', 3),
                const VerticalDivider(color: Colors.black), // Divider line
                _buildTimePeriodOption('1 Year', 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build each time period option
  Widget _buildTimePeriodOption(String label, int index) {
    bool isSelected = _selectedTimeIndex == index; // Check if this option is selected
    return GestureDetector(
      onTap: () => _onTimePeriodSelected(index), // Handle tap event
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Padding for the option
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.transparent, // Change color if selected
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // Change font weight if selected
            color: isSelected ? Colors.white : Colors.black, // Change text color if selected
          ),
        ),
      ),
    );
  }
}
