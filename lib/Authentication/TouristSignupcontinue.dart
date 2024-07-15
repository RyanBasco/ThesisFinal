import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Import for TapGestureRecognizer
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing/Authentication/TermsandConditions.dart';
import 'package:testing/Authentication/TouristLogin.dart';

class SignupContinue extends StatefulWidget {
  final String lastName;
  final String firstName;
  final String email;
  final String nationality;
  final String province;
  final String city;
  final String country;
  final String birthday;
  final String sex;
  final String civilStatus;

  SignupContinue({
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.nationality,
    required this.province,
    required this.city,
    required this.country,
    required this.birthday,
    required this.sex,
    required this.civilStatus,
  });

  @override
  _SignupContinueState createState() => _SignupContinueState();
}

class _SignupContinueState extends State<SignupContinue> {
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController(); // New controller

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPrivacyPolicyAccepted = false;
  String _passwordWarning = '';
  String _confirmPasswordWarning = '';

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _contactNumberController.text = ''; // Initialize contact number controller
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: Container(
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20), // Adjusted height for top spacing
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF114F3A),
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF114F3A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _purposeController,
                decoration: InputDecoration(
                  hintText: 'Purpose of Travel',
                  filled: true,
                  fillColor: Color(0xFF5CA14E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.travel_explore, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Color(0xFF5CA14E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
             TextFormField(
                    controller: _contactNumberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')), // Allow only digits and '+'
                      LengthLimitingTextInputFormatter(13), // Limit input to 15 characters (including '+')
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        // Ensure '+63' prefix is added if missing
                        if (newValue.text.isNotEmpty && !newValue.text.startsWith('+63')) {
                          return TextEditingValue(
                            text: '+63${newValue.text}', // Add '+63' prefix
                            selection: TextSelection.collapsed(offset: '+63'.length), // Place cursor after '+63'
                          );
                        }
                        return newValue;
                      }),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Contact Number',
                      filled: true,
                      fillColor: Color(0xFF5CA14E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.phone, color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Color(0xFF5CA14E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _passwordWarning = value.length < 6 ? 'Password should have a minimum of 6 characters' : '';
                  });
                },
              ),
              if (_passwordWarning.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _passwordWarning,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  filled: true,
                  fillColor: Color(0xFF5CA14E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _confirmPasswordWarning = value != _passwordController.text ? 'Passwords do not match' : '';
                  });
                },
              ),
              if (_confirmPasswordWarning.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _confirmPasswordWarning,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFF2C812A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'DATA PRIVACY NOTICE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          text: 'In compliance with RA 10173 or Data \n'
                              'Privacy Act of the Philippines, the \n'
                              'personal information you will be \n'
                              'providing below shall only be used \n'
                              'for the purposes of tourism statistical \n'
                              'reporting as per Section 38 of the \n'
                              'Republic Act No. 9593 or the Tourism \n'
                              'Act of 2009 and Section 121 of its \n'
                              'Implementing Rules and Regulations.\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: 'Agree to our ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TermsAndConditions(),
                                    ),
                                  );
                                },
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TermsAndConditions(),
                                    ),
                                  );
                                },
                            ),
                            TextSpan(text: '. View here.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _isPrivacyPolicyAccepted,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isPrivacyPolicyAccepted = newValue!;
                      });
                    },
                    activeColor: Color(0xFF2C812A),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermsAndConditions(),
                          ),
                        );
                      },
                      child: Text(
                        'I agree to the Privacy Policy, Terms and Conditions.',
                        style: TextStyle(
                          color: Color(0xFF114F3A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isPrivacyPolicyAccepted
                      ? () {
                          _registerUser();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF288F13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: Colors.black, fontSize: 14.5), // Add font size here
                    children: [
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 16, // Add font size here
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPageScreen(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
               SizedBox(height: 60),
            ],
          ),
        ),
      ),)
    );
  }

  void _registerUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        await saveUserData(userCredential.user!.uid);
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Account Registered'),
              content: Text('Your account has been successfully registered.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPageScreen()),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          _passwordWarning = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          _passwordWarning = 'The account already exists for that email.';
        } else {
          _passwordWarning = 'Failed to create account: ${e.message}';
        }
      });
    } catch (e) {
      print('Failed to create account: $e');
      setState(() {
        _passwordWarning = 'Failed to create account. Please try again later.';
      });
    }
  }

  Future<void> saveUserData(String userId) async {
    // Realtime Database reference
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child('UserID').child(userId);

    // Firestore reference
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');

    Map<String, dynamic> userData = {
      'last_name': widget.lastName,
      'first_name': widget.firstName,
      'email': _emailController.text,
      'nationality': widget.nationality,
      'province': widget.province,
      'city': widget.city,
      'country': widget.country,
      'birthday': widget.birthday,
      'sex': widget.sex,
      'password': _passwordController.text, // Store password securely (consider hashing in real apps)
      'civil_status': widget.civilStatus,
      'purpose_of_travel': _purposeController.text,
      'contact_number': _contactNumberController.text, // Include contact number
    };

    // Remove empty strings from the data before saving
    userData.removeWhere((key, value) => value == '');

    try {
      // Save to Realtime Database
      await userRef.set(userData);

      // Save to Firestore
      await usersCollection.doc(userId).set(userData);

      print('User data saved successfully');
    } catch (error) {
      print('Failed to save user data: $error');
      setState(() {
        _passwordWarning = 'Failed to save user data: $error';
      });
    }
  }
}
