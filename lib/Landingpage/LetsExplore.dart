import 'package:flutter/material.dart';
import 'package:testing/Landingpage/getstarted.dart';

class ExplorePage extends StatelessWidget {
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
              'assets/bag.png',
              width: 550,  // Set the desired width
              height: 350, // Set the desired height
            ),
            SizedBox(height: 20),
            Text(
              'Let’s Explore Guimaras',
              style: TextStyle(
                color: Color(0xFF2C812A),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'CinzelDecorative',
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40), // Add horizontal padding
              alignment: Alignment.center,
              child: Text(
                'Embark on an unforgettable journey\n'
                'through the picturesque landscapes\n'
                'and hidden gems of Guimaras, the\n'
                'pristine island paradise nestled in the\n'
                'heart of the Philippines.',
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
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GetStartedPage()),
                );
              },
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
