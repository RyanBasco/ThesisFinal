import 'package:flutter/material.dart';
import 'package:testing/Landingpage/EnjoyVac.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    // Call the function to navigate after 5 seconds
    _navigateToNextPage();
  }

  // Function to navigate to the next page after 5 seconds
  void _navigateToNextPage() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500), // Adjust animation duration
        ),
      );
    });
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
              Color(0xFFDEE77A),
              Color(0xFF7C8144),
            ],
             stops: [5.0, 3.2],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/Guimarasvist.png',
            fit: BoxFit.contain, // Adjust the image fit
            width: MediaQuery.of(context).size.width * 0.8, // Adjust the width as needed
            height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
          ),
        ),
      ),
    );
  }
}
