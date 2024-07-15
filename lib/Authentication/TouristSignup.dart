import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing/Authentication/TouristSignupcontinue.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedSex;
  String? _selectedCivilStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
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
                TextFormFieldWithIcon('Last Name', Icons.person, _lastNameController, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                }),
                TextFormFieldWithIcon('First Name', Icons.person, _firstNameController, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                }),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormFieldWithIcon(
                      'Birthday',
                      Icons.calendar_today,
                      TextEditingController(
                        text: _selectedDate != null ? DateFormat.yMMMMd().format(_selectedDate!) : '',
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF5CA14E),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.wc,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedSex,
                          items: [
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
                          decoration: InputDecoration(
                            hintText: 'Sex',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                          dropdownColor: Color(0xFF5CA14E),
                          style: TextStyle(color: Colors.white),
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
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF5CA14E),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.family_restroom,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCivilStatus,
                          items: [
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
                          decoration: InputDecoration(
                            hintText: 'Civil Status',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                          dropdownColor: Color(0xFF5CA14E),
                          style: TextStyle(color: Colors.white),
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
                TextFormFieldWithIcon('Nationality', Icons.flag, _nationalityController, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter nationality';
                  }
                  return null;
                }),
                TextFormFieldWithIcon('Province', Icons.location_city, _provinceController, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter province';
                  }
                  return null;
                }),
                TextFormFieldWithIcon('City/Municipality', Icons.location_city, _cityController, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter city/municipality';
                  }
                  return null;
                }),
                TextFormFieldWithIcon('Country of Residence', Icons.public, _countryController, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter country of residence';
                  }
                  return null;
                }),
                SizedBox(height: 40), // Added space below the form fields
                Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25), // Adding border radius to the button
                      color: Color(0xFF2C812A), // Setting button color
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Form is validated, proceed to next screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupContinue(
                              lastName: _lastNameController.text,
                              firstName: _firstNameController.text,
                              email: _emailController.text,
                              nationality: _nationalityController.text,
                              province: _provinceController.text,
                              city: _cityController.text,
                              country: _countryController.text,
                              birthday: _selectedDate != null ? DateFormat.yMMMMd().format(_selectedDate!) : '',
                              sex: _selectedSex ?? '',
                              civilStatus: _selectedCivilStatus ?? '',
                            )),
                          );
                        }
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 70), // Added more space under the button
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
    this.controller, {
    this.onIconPressed,
    this.validator,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF5CA14E),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              iconData,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: TextStyle(color: Colors.white),
              readOnly: readOnly,
              validator: validator,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
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
