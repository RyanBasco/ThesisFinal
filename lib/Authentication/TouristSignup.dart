import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for input formatters
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:testing/Authentication/TouristSignupcontinue.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  // Removed controllers for province, city, and country
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedSex;
  String? _selectedCivilStatus;
  String? _selectedNationality;
  

  // List to store the loaded nationalities
  List<String> _nationalities = [];

  @override
  void initState() {
    super.initState();
    // Load the nationalities from JSON file
    loadNationalities();
  }

  // Function to load nationalities.json file
  Future<void> loadNationalities() async {
    try {
      String jsonString = await rootBundle.loadString('assets/nationalities.json');
      final List<dynamic> jsonResponse = json.decode(jsonString);
      setState(() {
        _nationalities = jsonResponse.map((e) => e.toString()).toList();
      });
    } catch (e) {
      print('Error loading nationalities.json: $e');
      // Handle error, possibly set a default list or show a message
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
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
                const Padding(
                  padding: EdgeInsets.only(left: 10.0), // Adjust the value for more/less right padding
                  child: Text(
                    'Personal Information',
                    style: TextStyle(
                      color: Color(0xFF114F3A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
                const SizedBox(height: 8),
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
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormFieldWithIcon(
                      'Birthday',
                      Icons.calendar_today,
                      TextEditingController(
                        text: _selectedDate != null
                            ? DateFormat.yMMMMd().format(_selectedDate!)
                            : '',
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
               Container(
  margin: const EdgeInsets.symmetric(vertical: 10),
  padding: const EdgeInsets.symmetric(horizontal: 10),
  decoration: BoxDecoration(
    color: const Color(0xFF5CA14E),
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Row(
    children: [
      const Icon(
        Icons.wc,
        color: Colors.white,
      ),
      const SizedBox(width: 10),
      Expanded(
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          value: _selectedSex,
          items: const [
            DropdownMenuItem(
              value: 'Male',
              child: Text('Male', style: TextStyle(color: Colors.white)),
            ),
            DropdownMenuItem(
              value: 'Female',
              child: Text('Female', style: TextStyle(color: Colors.white)),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedSex = value;
            });
          },
          decoration: const InputDecoration(
  hintText: 'Sex',
  hintStyle: TextStyle(color: Colors.white),
  border: InputBorder.none,
  contentPadding: EdgeInsets.only(bottom: 8,top: 3.8), // Adjust to move text up slightly
),
          dropdownColor: const Color(0xFF5CA14E),
          style: const TextStyle(color: Colors.white, fontSize: 16), // Adjust font size for clarity
          iconEnabledColor: Colors.white,
          validator: (value) {
            if (value == null) {
              return 'Please select sex';
            }
            return null;
          },
        ),
      ),
    ],
  ),
),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5CA14E),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.family_restroom,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCivilStatus,
                          items: const [
                            DropdownMenuItem(
                              value: 'Single',
                              child: Text('Single', style: TextStyle(color: Colors.white)),
                            ),
                            DropdownMenuItem(
                              value: 'Married',
                              child: Text('Married', style: TextStyle(color: Colors.white)),
                            ),
                            DropdownMenuItem(
                              value: 'Divorced',
                              child: Text('Divorced', style: TextStyle(color: Colors.white)),
                            ),
                            DropdownMenuItem(
                              value: 'Widowed',
                              child: Text('Widowed', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCivilStatus = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Civil Status',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 8,top: 3.8),
                          ),
                          dropdownColor: const Color(0xFF5CA14E),
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select civil status';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Updated Nationality Field
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
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
                        child: DropdownButtonFormField<String>(
                          value: _selectedNationality, // Use the variable here
                          items: _nationalities.map((nationality) {
                            return DropdownMenuItem<String>(
                              value: nationality,
                              child: Text(nationality, style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedNationality = value; // Set the selected nationality
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Nationality',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 8,top: 3.8),
                          ),
                          dropdownColor: const Color(0xFF5CA14E),
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select nationality';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Removed Province, City/Municipality, and Country of Residence fields

                // Added Contact Number field
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5CA14E),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _contactNumberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      hintText: 'Contact Number',
                      hintStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: const Color(0xFF5CA14E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter contact number';
                      }
                      if (value.length < 11) {
                        return 'Contact number must be 11 digits';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 60), // Space below the form fields
                Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25), // Rounded button
                      color: const Color(0xFF2C812A), // Button color
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Form is validated, proceed to next screen
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupContinue(
                              lastName: _lastNameController.text,
                              firstName: _firstNameController.text,
                              email: _emailController.text,
                              selectedNationality: _selectedNationality ?? '', // Use the selected variable
                              contactNumber: _contactNumberController.text,
                              birthday: _selectedDate != null
                                  ? DateFormat.yMMMMd().format(_selectedDate!)
                                  : '',
                              sex: _selectedSex ?? '',
                              civilStatus: _selectedCivilStatus ?? '',
                            ),
                          ),
                        );
                        }
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 70), // Space under the button
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

class TextFormFieldWithIcon extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final TextEditingController controller;
  final Function? onIconPressed;
  final String? Function(String?)? validator;
  final bool readOnly;

  const TextFormFieldWithIcon(
    this.hintText,
    this.iconData,
    this.controller, {super.key, 
    this.onIconPressed,
    this.validator,
    this.readOnly = false,
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              iconData,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              readOnly: readOnly,
              validator: validator,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.white),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          if (iconData == Icons.visibility || iconData == Icons.visibility_off)
            IconButton(
              icon: Icon(
                iconData,
                color: Colors.white,
              ),
              onPressed: () {
                if (onIconPressed != null) onIconPressed!();
              },
            ),
        ],
      ),
    );
  }
}
