import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for input formatters
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:testing/Authentication/TouristSignupcontinue.dart';

class CountryCode {
  final String name;
  final String code;
  final String abbreviation;
  final int maxDigits;

  CountryCode({
    required this.name,
    required this.code,
    required this.abbreviation,
    required this.maxDigits,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(
      name: json['name'],
      code: json['code'],
      abbreviation: json['abbreviation'],
      maxDigits: json['maxDigits'],
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedSex;
  String? _selectedCivilStatus;
  String? _selectedNationality;

  // Restrict _countryCodes to only Philippines
  List<CountryCode> _countryCodes = [
    CountryCode(
        name: "Philippines", code: "+63", abbreviation: "PH", maxDigits: 10),
  ];
  CountryCode? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countryCodes[0];
  }

  // Directly populated list of nationalities
  final List<String> _nationalities = [
    "Afghan",
    "Albanian",
    "Algerian",
    "Andorran",
    "Angolan",
    "Antiguan",
    "Argentine",
    "Armenian",
    "Australian",
    "Austrian",
    "Azerbaijani",
    "Bahaman",
    "Bahraini",
    "Bangladeshi",
    "Barbadian",
    "Belarusian",
    "Belgian",
    "Belizean",
    "Beninese",
    "Bhutanese",
    "Bolivian",
    "Bosnian",
    "Botswanan",
    "Brazilian",
    "Bruneian",
    "Bulgarian",
    "Burkinabe",
    "Burundian",
    "Cabo Verdean",
    "Cambodian",
    "Cameroonian",
    "Canadian",
    "Central African",
    "Chadian",
    "Chilean",
    "Chinese",
    "Colombian",
    "Comoran",
    "Congolese",
    "Costa Rican",
    "Croatian",
    "Cuban",
    "Cypriot",
    "Czech",
    "Danish",
    "Djiboutian",
    "Dominican",
    "Ecuadorian",
    "Egyptian",
    "Emirati",
    "Equatorial Guinean",
    "Eritrean",
    "Estonian",
    "Eswatini",
    "Ethiopian",
    "Fijian",
    "Filipino",
    "Finnish",
    "French",
    "Gabonese",
    "Gambian",
    "Georgian",
    "German",
    "Ghanaian",
    "Greek",
    "Grenadian",
    "Guatemalan",
    "Guinean",
    "Guinean-Bissauan",
    "Guyanese",
    "Haitian",
    "Honduran",
    "Hungarian",
    "Icelander",
    "Indian",
    "Indonesian",
    "Iranian",
    "Iraqi",
    "Irish",
    "Israeli",
    "Italian",
    "Jamaican",
    "Japanese",
    "Jordanian",
    "Kazakhstani",
    "Kenyan",
    "Kiribati",
    "North Korean",
    "South Korean",
    "Kuwaiti",
    "Kyrgyz",
    "Laotian",
    "Latvian",
    "Lebanese",
    "Lesotho",
    "Liberian",
    "Libyan",
    "Liechtensteiner",
    "Lithuanian",
    "Luxembourger",
    "Madagascan",
    "Malawian",
    "Malaysian",
    "Maldivian",
    "Malian",
    "Maltese",
    "Marshallese",
    "Mauritanian",
    "Mauritian",
    "Mexican",
    "Micronesian",
    "Moldovan",
    "Monacan",
    "Mongolian",
    "Montenegrin",
    "Moroccan",
    "Mozambican",
    "Myanmarian",
    "Namibian",
    "Nauruan",
    "Nepalese",
    "Dutch",
    "New Zealander",
    "Nicaraguan",
    "Nigerien",
    "Nigerian",
    "North Macedonian",
    "Norwegian",
    "Omani",
    "Pakistani",
    "Palauan",
    "Panamanian",
    "Papua New Guinean",
    "Paraguayan",
    "Peruvian",
    "Polish",
    "Portuguese",
    "Qatari",
    "Romanian",
    "Russian",
    "Rwandan",
    "Saint Kitts and Nevisian",
    "Saint Lucian",
    "Saint Vincentian",
    "Samoan",
    "San Marinese",
    "Sao Tomean",
    "Saudi Arabian",
    "Senegalese",
    "Serbian",
    "Seychellois",
    "Sierra Leonean",
    "Singaporean",
    "Slovak",
    "Slovenian",
    "Solomon Islander",
    "Somali",
    "South African",
    "South Sudanese",
    "Spanish",
    "Sri Lankan",
    "Sudanese",
    "Surinamese",
    "Swedish",
    "Swiss",
    "Syrian",
    "Taiwanese",
    "Tajikistani",
    "Tanzanian",
    "Thai",
    "Timorese",
    "Togolese",
    "Tongan",
    "Trinidadian",
    "Tunisian",
    "Turkish",
    "Turkmen",
    "Tuvaluan",
    "Ugandan",
    "Ukrainian",
    "Uruguayan",
    "Uzbek",
    "Vanuatuan",
    "Vatican",
    "Venezuelan",
    "Vietnamese",
    "Yemeni",
    "Zambian",
    "Zimbabwean"
  ];

  @override
  void dispose() {
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
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Personal Information',
                    style: TextStyle(
                      color: Color(0xFF114F3A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // First Name and Last Name Fields
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
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormFieldWithIcon(
                      'Birthday',
                      Icons.calendar_today,
                      TextEditingController(
                        // Updated date format for display
                        text: _selectedDate != null
                            ? DateFormat('MMMM dd, yyyy').format(_selectedDate!)
                            : '',
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
                // Sex Dropdown
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
                      const Icon(Icons.wc, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _selectedSex,
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female',
                                  style: TextStyle(color: Colors.white)),
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
                            contentPadding:
                                EdgeInsets.only(bottom: 8, top: 3.8),
                          ),
                          dropdownColor: const Color(0xFF5CA14E),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
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
                // Civil Status Dropdown
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
                      const Icon(Icons.family_restroom, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCivilStatus,
                          items: const [
                            DropdownMenuItem(
                              value: 'Single',
                              child: Text('Single',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            DropdownMenuItem(
                              value: 'Married',
                              child: Text('Married',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            DropdownMenuItem(
                              value: 'Divorced',
                              child: Text('Divorced',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            DropdownMenuItem(
                              value: 'Widowed',
                              child: Text('Widowed',
                                  style: TextStyle(color: Colors.white)),
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
                            contentPadding:
                                EdgeInsets.only(bottom: 8, top: 3.8),
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
                // Nationality Dropdown
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
                      const Icon(Icons.flag, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedNationality,
                          items: _nationalities.map((nationality) {
                            return DropdownMenuItem<String>(
                              value: nationality,
                              child: Text(nationality,
                                  style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedNationality = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Nationality',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(bottom: 8, top: 3.8),
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

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5CA14E),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      // Country Code Dropdown
                      Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF5CA14E),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<CountryCode>(
                            value: _selectedCountry,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF5CA14E),
                            iconEnabledColor: Colors.white,
                            items: _countryCodes.map((country) {
                              return DropdownMenuItem<CountryCode>(
                                value: country,
                                child: Text(
                                  "${country.code} ${country.abbreviation}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              );
                            }).toList(),
                            onChanged: (CountryCode? newCountry) {
                              setState(() {
                                _selectedCountry = newCountry;
                                _contactNumberController.clear();
                              });
                            },
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 8), // Space between dropdown and contact field

                      // Contact Number Field
                      Expanded(
                        child: TextFormField(
                          controller: _contactNumberController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(
                                _selectedCountry?.maxDigits ?? 10),
                          ],
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Contact Number',
                            hintStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Color(0xFF5CA14E),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (value.length <
                                  (_selectedCountry?.maxDigits ?? 10)) {
                                return 'Contact number must be ${_selectedCountry?.maxDigits} digits';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xFF2C812A),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Only prepend the country code if the contact number field is not empty
                          final contactNumberWithCountryCode =
                              _contactNumberController.text.isNotEmpty
                                  ? '${_selectedCountry?.code}${_contactNumberController.text}'
                                  : '';

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupContinue(
                                lastName: _lastNameController.text,
                                firstName: _firstNameController.text,
                                email: _emailController.text,
                                selectedNationality: _selectedNationality ?? '',
                                contactNumber: contactNumberWithCountryCode,
                                birthday: _selectedDate != null
                                    ? DateFormat('MM/dd/yyyy').format(
                                        _selectedDate!) // Save as MM/DD/YYYY
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
                const SizedBox(height: 40),
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
        // Use 'MMMM dd, yyyy' format for display
        _birthdayController.text =
            DateFormat('MMMM dd, yyyy').format(_selectedDate!);
      });
    }
  }
}

// Custom widget for text fields with icons
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
    super.key,
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
