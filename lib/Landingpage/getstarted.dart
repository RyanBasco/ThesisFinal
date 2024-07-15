import 'package:flutter/material.dart';
import 'package:testing/Authentication/TouristLogin.dart';

class GetStartedPage extends StatefulWidget {
  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  int _currentIndex = 0;

  final List<String> _titles = [
    'Get Started!',
    'Register',
    'List Itinerary',
    'Explore'
  ];

  final List<String> _descriptions = [
    'Begin your journey to discovering the\nwonders of Guimaras with just a few\nsimple steps. Let\'s embark on this\nadventure together!',
    'Unlock the full potential of Guimaras\nVIST by creating your account today.\nSign up now to access, explore features,\nand more.',
    'Organize your Guimaras escapade\neffortlessly by creating custom itineraries\ntailored to your preferences. Plan your\ndays, explore hidden gems, and make\nevery moment count.',
    'Dive into the enchanting realm of\nGuimaras and uncover its treasures\nwaiting to be explored.'
  ];

  final List<String> _imagePaths = [
    'assets/mountain.png',
    'assets/people.png', // Replace with actual image path
    'assets/basket.png',  // Replace with actual image path
    'assets/map.png', // Replace with actual image path
  ];

  void _nextPage() {
    if (_currentIndex < 3) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPageScreen()), // Navigate to the login page
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _imagePaths[_currentIndex],
              width: _currentIndex == 0 ? 450 : 300, // Increase width for the mountain image
              height: _currentIndex == 0 ? 300 : 300, // Increase height for the mountain image
            ),
            SizedBox(height: 20), // Spacing between image and dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Color(0xFF2C812A) : Colors.white,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            SizedBox(height: 10),
            Text(
              _titles[_currentIndex],
              style: TextStyle(
                color: Color(0xFF2C812A),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                _descriptions[_currentIndex],
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 30),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF3C721B),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: _nextPage,
              child: Text(
                'Next >',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
