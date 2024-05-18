import 'package:flutter/material.dart';
import 'package:testing/Landingpage/getstarted.dart';

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFDEE77A),
              Color(0xFF7C8144),
            ],
            stops: [5.0, 3.2],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/tourist.png',
              width: 350,  // Set the desired width
              height: 350, // Set the desired height
            ),
            SizedBox(height: 20),
            Text(
              'Enjoy your Vacation!',
              style: TextStyle(
                color: Color(0xFF2C812A),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Let\'s explore Guimaras',
              style: TextStyle(
                color: Color(0xFF2C812A),
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40), // Add horizontal padding
              alignment: Alignment.centerLeft,  // Align text to the left
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
                backgroundColor: Color(0xFF114F3A),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GetStartedPage()),
                );
              },
              child: Text(
                'Get Started',
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
