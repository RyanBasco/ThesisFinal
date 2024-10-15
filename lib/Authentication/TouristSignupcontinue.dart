import 'dart:convert';
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
  final String selectedNationality;
  final String contactNumber; // New Required Parameter
  final String birthday;
  final String sex;
  final String civilStatus;

  const SignupContinue({super.key, 
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.selectedNationality,
    required this.contactNumber, // Added
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
  List<String> _countries = [];
  List<String> _purposeOptions = [];
  String? _selectedPurpose;
  String? _selectedCountry;
  String? _otherPurpose;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _contactNumberController.text = ''; // Initialize contact number controller
    loadCountries();
    _loadPurposeOptions();
  }

        Future<void> _loadPurposeOptions() async {
    // Load the JSON file
    final String response = await rootBundle.loadString('assets/purposeoftravel.json');
    final data = await json.decode(response);
    setState(() {
      _purposeOptions = List<String>.from(data['purpose_of_travel']);
    });
  }
      Future<void> loadCountries() async {
      try {
        String jsonString = await rootBundle.loadString('assets/countries.json');
        final List<dynamic> jsonResponse = json.decode(jsonString);
        setState(() {
          _countries = jsonResponse.map((e) => e.toString()).toList();
        });
      } catch (e) {
        print('Error loading countries.json: $e');
        // Handle error, possibly set a default list or show a message
      }
    }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: Container(
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20), // Adjusted height for top spacing
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF114F3A),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF114F3A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
                  const Text(
                    'Residence Information',
                    style: TextStyle(
                      color: Color(0xFF114F3A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 3),
              const SizedBox(height: 3),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 0),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF5CA14E),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.flag,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Transform.translate(
                        offset: const Offset(0, -5), // Moves the text upward by 5 pixels
                        child: DropdownButtonFormField<String>(
                          value: _selectedCountry,
                          items: _countries.map((country) {
                            return DropdownMenuItem<String>(
                              value: country,
                              child: Text(country, style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCountry = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Country of Residence',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                          dropdownColor: const Color(0xFF5CA14E),
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select country of residence';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
               const SizedBox(height: 10),
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      color: Color(0xFF114F3A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
             Column(
  children: [
    const SizedBox(height: 3),
Container(
  margin: const EdgeInsets.symmetric(vertical: 0),
  padding: const EdgeInsets.symmetric(horizontal: 10),
  decoration: BoxDecoration(
    color: const Color(0xFF5CA14E),
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Column(
    children: [
      Row(
        children: [
          const Icon(
            Icons.travel_explore_rounded,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -5), // Moves the text upward by 5 pixels
              child: DropdownButtonFormField<String>(
                value: _selectedPurpose,
                items: _purposeOptions.map((country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPurpose = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Country of Residence',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                dropdownColor: const Color(0xFF5CA14E),
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.white,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select country of residence';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
      if (_selectedPurpose == 'OTHERS') ...[
                const SizedBox(height: 20), // Add space between the dropdown and the input field
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Please Specify',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        _otherPurpose = value; // Store the input value
              });
            },
          ),
        ),
    ],
            ]),
),

               const SizedBox(height: 13),
                  const Text(
                    'Credentials',
                    style: TextStyle(
                      color: Color(0xFF114F3A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              const SizedBox(height: 3),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: const Color(0xFF5CA14E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.email, color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: const Color(0xFF5CA14E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
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
                style: const TextStyle(color: Colors.white),
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
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  filled: true,
                  fillColor: const Color(0xFF5CA14E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
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
                style: const TextStyle(color: Colors.white),
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
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C812A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'DATA PRIVACY NOTICE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Agree to our ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
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
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: const TextStyle(
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
                            const TextSpan(text: '. View here.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _isPrivacyPolicyAccepted,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isPrivacyPolicyAccepted = newValue!;
                      });
                    },
                    activeColor: const Color(0xFF2C812A),
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
                      child: const Text(
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
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isPrivacyPolicyAccepted
                      ? () {
                          _registerUser();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF288F13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: const TextStyle(color: Colors.black, fontSize: 14.5), // Add font size here
                    children: [
                      TextSpan(
                        text: 'Log in',
                        style: const TextStyle(
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
               const SizedBox(height: 60),
            ],
          ),
        ]),
      ),)
    ));
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
              title: const Text('Account Registered'),
              content: const Text('Your account has been successfully registered.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
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
    'nationality': widget.selectedNationality,
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
    print('User data saved successfully to Realtime Database.');

    // Save to Firestore
    await usersCollection.doc(userId).set(userData);
    print('User data saved successfully to Firestore.');
  } catch (error) {
    print('Failed to save user data: $error');
    setState(() {
      _passwordWarning = 'Failed to save user data: $error';
    });
  }
}
}
