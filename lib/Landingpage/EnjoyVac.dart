import 'package:flutter/material.dart';
import 'package:testing/Landingpage/LetsExplore.dart';
import 'package:testing/Landingpage/getstarted.dart';

class NextPage extends StatelessWidget {
  const NextPage({super.key});

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
              'assets/mango.png',
              width: 550,  // Set the desired width
              height: 350, // Set the desired height
            ),
            const SizedBox(height: 20),
            const Text(
              'WELCOME TO GUIMARAS!',
              style: TextStyle(
                color: Color(0xFF2C812A),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'CinzelDecorative',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Province of Guimaras',
              style: TextStyle(
                color: Color(0xFF2C812A),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40), // Add horizontal padding
              alignment: Alignment.center,
              child: const Text(
                'THE ISLAND THAT FITS YOUR TASTE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF114F3A),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
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
                  MaterialPageRoute(builder: (context) => ExplorePage()),
                );
              },
              child: const Text(
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
