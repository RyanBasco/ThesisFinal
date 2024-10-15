import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth library
import 'package:firebase_database/firebase_database.dart'; // Import FirebaseDatabase library
import 'package:testing/Authentication/EstablishmentLogin.dart';

class EstablishmentsignupPage extends StatefulWidget {
  const EstablishmentsignupPage({super.key});

  @override
  _EstablishmentsignupPageState createState() => _EstablishmentsignupPageState();
}

class _EstablishmentsignupPageState extends State<EstablishmentsignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _establishmentNameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactinfoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final bool _emailExists = false;

  final List<String> _types = [
    'Hotels',
    'Hostels',
    'Vacation Rentals',
    'Campsites and RV Parks',
    'Tour Operators',
    'Restaurants and Cafes',
    'Travel Agencies',
    'Attractions and Entertainment Venues',
    'Transportation Services',
    'Visitor Information Centers',
    'Spas and Wellness Centers',
    'Shopping Centers and Souvenir Shops',
    'Adventure and Eco-Tourism Operators',
    'Others',
  ];

  String? _selectedType;

  // Firebase instance variables
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
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
                    const SizedBox(width: 10),
                    const Text(
                      'Sign Up to Establishment',
                      style: TextStyle(
                        color: Color(0xFF114F3A),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInputContainer(
                  'Establishment Name',
                  _establishmentNameController,
                  icon: Icons.business,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the establishment name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                _buildDropdownContainer(
                  hintText: 'Type',
                  icon: Icons.category,
                  items: _types.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                _buildInputContainer(
                  'Location',
                  _locationController,
                  icon: Icons.location_on,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                _buildContactInfoContainer(),
                const SizedBox(height: 5),
                _buildInputContainer(
                  'Email',
                  _emailController,
                  icon: Icons.email,
                  isPassword: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                _buildInputContainer(
                  'Password',
                  _passwordController,
                  icon: Icons.lock,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 5) {
                      return 'Password must be at least 5 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _registerEstablishment();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C812A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(200, 50),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account yet? ',
                      style: TextStyle(
                        color: Colors.black, // Change color to black
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EstablishmentLoginPage()),
                        );
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          color: Color(0xFF2D60F7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputContainer(String hintText, TextEditingController controller, {bool isPassword = false, IconData? icon, String? Function(String?)? validator}) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20), // Increase horizontal padding
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF5CA14E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              obscureText: isPassword && _obscurePassword,
              validator: validator,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
          if (isPassword) // Add eye icon to reveal password
            IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDropdownContainer({required String hintText, required IconData icon, required List<DropdownMenuItem<String>> items, required Function(String?) onChanged, String? Function(String?)? validator}) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20), // Increase horizontal padding
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF5CA14E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                hint: Text(
                  hintText,
                  style: const TextStyle(color: Colors.white),
                ),
                iconEnabledColor: Colors.white,
                items: items,
                onChanged: onChanged,
                value: _selectedType,
                style: const TextStyle(color: Colors.white), // Set text color of selected value
                dropdownColor: Colors.grey[600], // Set background color of dropdown items
                elevation: 16, // Increase elevation to make the dropdown appear above other widgets
                isExpanded: true, // Allow the dropdown to take up the entire width
                validator: validator,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoContainer() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20), // Increase horizontal padding
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF5CA14E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.phone,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _contactinfoController,
              style: const TextStyle(color: Colors.white),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow numeric input
                LengthLimitingTextInputFormatter(11), // Limit to 11 characters
              ],
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter contact info';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Contact Info',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _registerEstablishment() async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get the user ID
      String establishmentId = userCredential.user!.uid;

      // Store additional establishment data in Firebase Realtime Database
      await _database.ref().child('EstablishmentID').child(establishmentId).set({
        'establishmentName': _establishmentNameController.text.trim(),
        'type': _selectedType,
        'location': _locationController.text.trim(),
        'contactInfo': _contactinfoController.text.trim(),
        'email': _emailController.text.trim(),
      });

      // Show a snackbar with the success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Establishment registered successfully!'),
        ),
      );

      // Navigate back to the login page after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EstablishmentLoginPage()),
        );
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
