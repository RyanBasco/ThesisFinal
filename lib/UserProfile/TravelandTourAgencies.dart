import 'package:flutter/material.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class Travelandtouragencies extends StatefulWidget {
  const Travelandtouragencies({super.key});

  @override
  _TravelandtouragenciesState createState() => _TravelandtouragenciesState();
}

class _TravelandtouragenciesState extends State<Travelandtouragencies> {
  int _selectedIndex = 3;

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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage()),
        );
        break;
      case 3:
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.close, color: Colors.black, size: 30),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, bottom: 10),
                child: Text(
                  'Travel and Tour\nAgencies',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // SAN MIGUEL, JORDAN
                    _buildLocationCard(
                      'SAN MIGUEL, JORDAN',
                      Icons.business_center,
                      [
                        _buildAgencyRow(
                          'CHERALD TRAVEL AND TOURS',
                          'MR. CHERALD PADOJENG',
                          '09084748122 / 09179647934',
                        ),
                        _buildAgencyRow(
                          'MARRIANE GELARAGA TRAVEL AND TOURS',
                          'MS. MARIANNE GALARAGA',
                          '0997439011 / 09484127873',
                        ),
                        _buildAgencyRow(
                          'GENNED-UP TRAVEL EVENTS AND SEMINARS, INC.',
                          'MS. GENNEL SEGOVIA',
                          '09257589553 / 09228025200',
                        ),
                        _buildAgencyRow(
                          'JUZLEN TRAVEL AND TOURS',
                          'MS. JUSTINE KENNETH LEGADA',
                          '09605892748',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // ZALDIVAR, BUENAVISTA
                    _buildLocationCard(
                      'ZALDIVAR, BUENAVISTA',
                      Icons.location_city,
                      [
                        _buildAgencyRow(
                          'ANGELY TRAVEL AND TOURS',
                          'FACEBOOK NAME: DAN ANGELO DANG',
                          '',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // HOSKYN, JORDAN
                    _buildLocationCard(
                      'HOSKYN, JORDAN',
                      Icons.map,
                      [
                        _buildAgencyRow(
                          'AVA TRAVEL AND TOURS',
                          'MR. VINCENT ABAWAN',
                          '09084748122 / 09179647934',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // BALCON MELLIZA, JORDAN
                    _buildLocationCard(
                      'BALCON MELLIZA, JORDAN',
                      Icons.location_pin,
                      [
                        _buildAgencyRow(
                          'YESHUA TRAVEL AND TOURS',
                          'MS. RICHEL MALIMIT',
                          '09171451937',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(String location, IconData icon, List<Widget> agencies) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: const BoxDecoration(
            color: Color(0xFF83E6F4),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.redAccent, size: 24), // Icon for location
              const SizedBox(width: 8),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: const BoxDecoration(
            color: Color(0xFF288F13),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Column(
            children: agencies,
          ),
        ),
      ],
    );
  }

  Widget _buildAgencyRow(String agencyName, String contactPerson, String phoneNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  agencyName,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (phoneNumber.isNotEmpty)
                Text(
                  phoneNumber,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          Text(
            contactPerson,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
