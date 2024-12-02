import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:testing/Authentication/TouristLogin.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveUserToDatabase(User user) async {
    await databaseReference.child('Users/${user.uid}').set({
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'email': _emailController.text,
    });
  }

  Future<void> _registerUser(BuildContext context) async {
  setState(() {
    _isLoading = true;
  });

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    await _saveUserToDatabase(userCredential.user!);

    setState(() {
      _isLoading = false;
    });

    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Account successfully registered!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPageScreen(), // Redirect to Login Screen
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  } on FirebaseAuthException catch (e) {
    setState(() {
      _isLoading = false;
    });

    // Show error dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(e.message ?? 'An error occurred. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
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
                        const SizedBox(width: 120),
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
                    const SizedBox(height: 20),
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            color: Color(0xFF114F3A),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    const SizedBox(height: 10),
                    TextFormFieldWithIcon(
                      'First Name',
                      Icons.person,
                      _firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),
                    TextFormFieldWithIcon(
                      'Last Name',
                      Icons.person,
                      _lastNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),
                    TextFormFieldWithIcon(
                      'Email',
                      Icons.email,
                      _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    TextFormFieldWithIcon(
                      'Password',
                      Icons.lock,
                      _passwordController,
                      isPassword: true,
                      isVisible: _isPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    TextFormFieldWithIcon(
                      'Confirm Password',
                      Icons.lock,
                      _confirmPasswordController,
                      isPassword: true,
                      isVisible: _isConfirmPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFF2C812A),
                        ),
                        child: TextButton(
                          onPressed: !_isLoading
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    _registerUser(context);
                                  }
                                }
                              : null,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFormFieldWithIcon extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final TextEditingController controller;
  final bool isPassword;
  final bool isVisible;
  final VoidCallback? toggleVisibility;
  final String? Function(String?)? validator;

  const TextFormFieldWithIcon(
    this.hintText,
    this.iconData,
    this.controller, {
    super.key,
    this.isPassword = false,
    this.isVisible = false,
    this.toggleVisibility,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF5CA14E),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !isVisible,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(iconData, color: Colors.white),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: toggleVisibility,
                )
              : null,
        ),
      ),
    );
  }
}
