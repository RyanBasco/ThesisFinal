import 'package:flutter/material.dart';
import 'package:testing/Authentication/TouristSignup.dart';


class LoginPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 150),
                Image.asset(
                  'assets/Guimarasvist.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 15),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF5CA14E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                          onTap: () {
                            // Move the hint text up when tapped
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 15),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF5CA14E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                          onTap: () {
                            // Move the hint text up when tapped
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF2C812A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Login button pressed
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    // Navigate to signup page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Text(
                    "Don't have an account yet? ",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to signup page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF2D60F7), // Blue color
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.business,
                color: Color(0xFF114F3A),
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
