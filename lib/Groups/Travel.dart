import 'package:flutter/material.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/Groups/QRCodeDisplayPage.dart';
import 'package:testing/Groups/TouristSignupcontinue.dart';
import 'package:testing/Groups/History.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class QRPage extends StatefulWidget {
  const QRPage({super.key});

  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  int _selectedIndex = 1;
  bool _isRegistered = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
  }

  Future<void> _checkRegistrationStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseEvent event = await FirebaseDatabase.instance
            .ref()
            .child('Users/${user.uid}')
            .once();

        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> userData = event.snapshot.value as Map<dynamic, dynamic>;

          if (mounted) {
            setState(() {
              _isRegistered = userData['isRegistered'] == true;
            });
          }
        }
      }
    } catch (e) {
      print('Error checking registration status: $e');
      if (mounted) {
        setState(() {
          _isRegistered = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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

    // Use pushAndRemoveUntil to clear the navigation stack and prevent animations
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero, // No transition animation
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }

  // Define the _viewQRCode method
  void _viewQRCode(String formId, String firstName, String lastName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRCodeDisplayPage(
          formId: formId,
          firstName: firstName,
          lastName: lastName,
        ),
      ),
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
  animationDuration: const Duration(milliseconds: 333000),
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
        Text('Transaction', 
          style: TextStyle(
            color: _selectedIndex == 2 ? const Color(0xFF27AE60) : Colors.grey, 
            fontSize: 10
          ),
          overflow: TextOverflow.ellipsis,
        ),
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
    setState(() {
      _selectedIndex = index;
    });
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
                    _isLoading 
                      ? CircularProgressIndicator()
                      : Column(
                          children: [
                            if (!_isRegistered) 
                              _buildTravelRegistrationBox(),
                            if (_isRegistered)
                              GestureDetector(
                                onTap: () {
                                  _viewQRCode('sampleFormId', 'John', 'Doe');
                                },
                                child: Container(
                                  height: 120,
                                  width: 280,
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(9),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 7),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.qr_code,
                                        size: 60,
                                        color: Color(0xFF288F13),
                                      ),
                                      const SizedBox(width: 15),
                                      const Text(
                                        'View QR Code',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                  ],
                ),
              ),
            ],
          ),
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
