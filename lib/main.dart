import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testing/Landingpage/landingpage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey:  "AIzaSyCWzF8ETNg8zZVB4vobis1SDCoYFZ7abWg", 
        appId: "1:920622301670:android:366554dc49dfc717e51627", 
        messagingSenderId: "920622301670", 
        projectId: "testingapp-589a1",
        storageBucket: "testingapp-589a1.appspot.com",
        )
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  LandingPage(), // Change to LandingPage
    );
  }
}
