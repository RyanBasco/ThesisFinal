import 'package:flutter/material.dart';
import 'package:testing/Landingpage/getstarted.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/bag.png',
              width: 550,  // Set the desired width
              height: 350, // Set the desired height
            ),
            const SizedBox(height: 20),
            const Text(
              'Let’s Explore Guimaras',
              style: TextStyle(
                color: Color(0xFF2C812A),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'CinzelDecorative',
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40), // Add horizontal padding
              alignment: Alignment.center,
              child: const Text(
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
            const SizedBox(height: 30),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF3C721B),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
              child: const Text(
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
