import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/Authentication/TouristLogin.dart';
import 'package:testing/Landingpage/landingpage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCWzF8ETNg8zZVB4vobis1SDCoYFZ7abWg",
        appId: "1:920622301670:android:366554dc49dfc717e51627",
        messagingSenderId: "920622301670",
        projectId: "testingapp-589a1",
        storageBucket: "testingapp-589a1.appspot.com",
      ),
    );
  }

  // Check if it's the first time the app is being opened
  final bool isFirstLaunch = await checkFirstLaunch();

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

// Function to check if this is the first launch
Future<bool> checkFirstLaunch() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    await prefs.setBool('isFirstLaunch', false); // Set as not first launch
  }

  return isFirstLaunch;
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isFirstLaunch ? LandingPage() : LoginPageScreen(), // Conditionally show page
    );
  }
}
