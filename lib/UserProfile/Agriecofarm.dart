import 'package:flutter/material.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/Groups/History.dart';
import 'package:testing/Groups/Travel.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Agriecofarm extends StatefulWidget {
  const Agriecofarm({super.key});

  @override
  _AgriecofarmState createState() => _AgriecofarmState();
}

class _AgriecofarmState extends State<Agriecofarm> {
  int _selectedIndex = 4;

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
        page = QRPage();
        break;
      case 2:
        page = RegistrationPage();
        break;
      case 3:
        page = HistoryPage();
        break;
      case 4:
        page = TouristprofilePage();
        break;
      default:
        return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFF51F643),
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 65,
        index: _selectedIndex,
        animationDuration: const Duration(milliseconds: 333),
        animationCurve: Curves.easeInOut,
        items: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home, size: 24, color: _selectedIndex == 0 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Home', style: TextStyle(color: _selectedIndex == 0 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.travel_explore, size: 24, color: _selectedIndex == 1 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Travel', style: TextStyle(color: _selectedIndex == 1 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.attach_money, size: 24, color: _selectedIndex == 2 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Transaction', style: TextStyle(color: _selectedIndex == 2 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 24, color: _selectedIndex == 3 ? const Color(0xFF27AE60) : Colors.grey),
              Text('History', style: TextStyle(color: _selectedIndex == 3 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person, size: 24, color: _selectedIndex == 4 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Profile', style: TextStyle(color: _selectedIndex == 4 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
        onTap: (index) {
          _onItemTapped(index);
        },
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
                        Navigator.pop(context); // Navigate back to the previous page
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
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  'Agri-Eco Farm\nSites',
                  style: TextStyle(
                    fontSize: 28, // Reduced font size for closer match
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
                    _buildFarmSite(
                      title1: 'ORACON SUR, NUEVA VALENCIA',
                      subtitle1: 'DOM’S FARM AND THE \n RIDERS CAMP',
                      contact1: '092050500 / 09778049860',
                      title2: 'SAN ENRIQUE, SAN LORENZO',
                      subtitle2: 'FATIMA FARM \nRESORT',
                      contact2: '09171250016',
                    ),
                    const SizedBox(height: 12),
                    _buildFarmSite(
                      title1: 'MILLIAN, SIBUNAG',
                      subtitle1: 'JEM HOME FARM ECO \n ADVENTURES',
                      contact1: '09189659525 / 09209464522',
                      title2: 'OLD POBLACION, BUENAVISTA',
                      subtitle2: 'MAE’S FARM',
                      contact2: '09177191929 / 09207991929',
                    ),
                    const SizedBox(height: 12),
                    _buildFarmSite(
                      title1: 'CONCORDIA NORTE, SIBUNAG',
                      subtitle1: 'SPRING BLOOM \nAGRI -FARM',
                      contact1: '09307122209',
                      title2: 'CABANO, SAN LORENZO',
                      subtitle2: 'SUNRISE VALLEY \nOCEAN VIEW RESORT',
                      contact2: '09171175735 / 09287491710',
                    ),
                    const SizedBox(height: 12),
                    _buildSingleFarmSite(
                      title: 'ALAGUISOC, JORDAN',
                      subtitle: 'WONDER’S FARM',
                      contact: '09173261142 / 09177071142',
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

  Widget _buildFarmSite({
    required String title1,
    required String subtitle1,
    required String contact1,
    required String title2,
    required String subtitle2,
    required String contact2,
  }) {
    return Column(
      children: [
        Row(
          children: [
            _buildTitleBox(title1, height: 50), // Adjust height as needed
            const SizedBox(width: 10),
            _buildTitleBox(title2, height: 50), // Adjust height as needed
          ],
        ),
        Row(
          children: [
            _buildDetailBox(subtitle1, contact1, height: 100), // Adjust height as needed
            const SizedBox(width: 10),
            _buildDetailBox(subtitle2, contact2, height: 100), // Adjust height as needed
          ],
        ),
      ],
    );
  }

  Widget _buildSingleFarmSite({
    required String title,
    required String subtitle,
    required String contact,
  }) {
    return Column(
      children: [
        Row(
          children: [
            _buildTitleBox(title, height: 50), // Adjust height as needed
          ],
        ),
        Row(
          children: [
            _buildDetailBox(subtitle, contact, height: 60), // Adjust height as needed
          ],
        ),
      ],
    );
  }

  Widget _buildTitleBox(String title, {double height = 40}) {
    return Expanded(
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          color: Color(0xFF83E6F4),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBox(String subtitle, String contact, {double height = 60}) {
    return Expanded(
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          color: Color(0xFF288F13),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13, // Reduced font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                contact,
                style: const TextStyle(
                  fontSize: 13, // Reduced font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
