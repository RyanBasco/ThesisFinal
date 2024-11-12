import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:testing/Authentication/Forgetpass.dart';
import 'package:testing/Authentication/TouristSignup.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class LoginPageScreen extends StatefulWidget {
  const LoginPageScreen({super.key});

  @override
  _LoginPageScreenState createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true; // Added to toggle password visibility
  bool _isLoading = false; // Added to indicate loading state

  Future<void> _login(BuildContext context) async {
  // Validate form input
  if (!_formKey.currentState!.validate()) {
    return;
  }

  // Show loading indicator
  setState(() {
    _isLoading = true;
  });

  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      print("User authenticated successfully.");

      DatabaseReference userRef =
          _database.child('Users').child(userCredential.user!.uid);
      DatabaseEvent userEvent = await userRef.once();

      if (userEvent.snapshot.exists) {
        if (mounted) {
          // Navigate to User Dashboard if user exists
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserdashboardPageState()),
          );
        }
      } else {
        // Sign out if user data not found in database
        await _auth.signOut();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login failed: Invalid email or password."),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to login: Invalid email or password."),
          ),
        );
      }
    }
  } catch (e) {
    print("Failed to login: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to login: $e"),
        ),
      );
    }
  } finally {
    // Hide loading indicator
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


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
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  16.0, 35.0, 16.0, 16.0), // Adjust this value to move down
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: Image.asset(
                        'assets/Newlogo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 0),

                  // "Login" Text
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF288F13), // Color #288F13
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Field with Icon
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFF5CA14E), // Background color for email field
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.email,
                                  color: Colors.white), // Email Icon
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                color: Colors.white), // White text inside
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password Field with Icon
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFF5CA14E), // Background color for password field
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.white),
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.lock,
                                  color: Colors.white), // Lock Icon
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            style: const TextStyle(
                                color: Colors.white), // White text inside
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhoneAuthPage()),
                        );
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.black, // Black text color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Login Button
                  Center(
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C812A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                _login(context);
                              },
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // "Don't have an account? Sign up" text
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(
                                color: Color(0xFF2D60F7), // Sign up text color
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
