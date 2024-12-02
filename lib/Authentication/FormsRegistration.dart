import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

class TravelRegistrationPage extends StatefulWidget {
  const TravelRegistrationPage({super.key});

  @override
  _TravelRegistrationPageState createState() => _TravelRegistrationPageState();
}

class _TravelRegistrationPageState extends State<TravelRegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _specifyPurposeController =
      TextEditingController();

  bool _isLoading = false;
  bool _isPrivacyPolicyAccepted = false;

  // Dropdown data
  List<String> _countries = [];
  List<String> _purposeOptions = [];
  List<String> _nationalities = [];
  final List<String> _maritalStatuses = [
    'Single',
    'Married',
    'Widowed',
    'Divorced'
  ];

  String? _selectedCountry;
  String? _selectedPurpose;
  String? _selectedNationality;
  String? _selectedMaritalStatus;

  // Local Address Data
  List<dynamic> _regions = [];
  List<dynamic> _provinces = [];
  List<dynamic> _cities = [];
  List<dynamic> _barangays = [];

  String? _selectedRegion;
  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedBarangay;

  bool _isLoadingRegions = false;
  bool _isLoadingProvinces = false;
  bool _isLoadingCities = false;
  bool _isLoadingBarangays = false;

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  @override
  void dispose() {
    _contactController.dispose();
    _specifyPurposeController.dispose();
    super.dispose();
  }

  Future<void> _loadDropdownData() async {
    try {
      // Load countries.json
      String countriesJson =
          await rootBundle.loadString('assets/countries.json');
      List<dynamic> countriesList = json.decode(countriesJson);

      // Load purposeoftravel.json
      String purposeJson =
          await rootBundle.loadString('assets/purposeoftravel.json');
      Map<String, dynamic> purposeData = json.decode(purposeJson);

      // Load nationalities.json
      String nationalitiesJson =
          await rootBundle.loadString('assets/nationalities.json');
      Map<String, dynamic> nationalityData = json.decode(nationalitiesJson);

      setState(() {
        _countries = List<String>.from(countriesList);
        _purposeOptions = List<String>.from(purposeData['purpose_of_travel']);
        _nationalities = List<String>.from(nationalityData['nationalities']);
      });
    } catch (e) {
      print('Error loading dropdown data: $e');
    }
  }

  Future<void> _loadRegions() async {
    try {
      setState(() {
        _isLoadingRegions = true;
      });
      String regionsJson = await rootBundle.loadString('assets/region.json');
      setState(() {
        _regions = json.decode(regionsJson);
        _isLoadingRegions = false;
      });
    } catch (e) {
      print('Error loading regions: $e');
      setState(() {
        _isLoadingRegions = false;
      });
    }
  }

  Future<void> _loadProvinces(String region) async {
    try {
      setState(() {
        _isLoadingProvinces = true;
      });
      String provincesJson =
          await rootBundle.loadString('assets/province.json');
      setState(() {
        _provinces = json
            .decode(provincesJson)
            .where((province) => province['region'] == region)
            .toList();
        _isLoadingProvinces = false;
      });
    } catch (e) {
      print('Error loading provinces: $e');
      setState(() {
        _isLoadingProvinces = false;
      });
    }
  }

  Future<void> _loadCities(String province) async {
    try {
      setState(() {
        _isLoadingCities = true;
      });
      String citiesJson = await rootBundle.loadString('assets/city.json');
      setState(() {
        _cities = json
            .decode(citiesJson)
            .where((city) => city['province'] == province)
            .toList();
        _isLoadingCities = false;
      });
    } catch (e) {
      print('Error loading cities: $e');
      setState(() {
        _isLoadingCities = false;
      });
    }
  }

  Future<void> _loadBarangays(String city) async {
    try {
      setState(() {
        _isLoadingBarangays = true;
      });
      String barangaysJson =
          await rootBundle.loadString('assets/barangay.json');
      setState(() {
        _barangays = json
            .decode(barangaysJson)
            .where((barangay) => barangay['city'] == city)
            .toList();
        _isLoadingBarangays = false;
      });
    } catch (e) {
      print('Error loading barangays: $e');
      setState(() {
        _isLoadingBarangays = false;
      });
    }
  }

  Future<void> _registerTraveler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref();
      final String userId = databaseReference.child('Travelers').push().key!;

      // Save data to Firebase Realtime Database
      await databaseReference.child('Travelers/$userId').set({
        'contact': _contactController.text.trim(),
        'country_of_residence': _selectedCountry,
        'purpose_of_travel': _selectedPurpose == 'Other'
            ? _specifyPurposeController.text.trim()
            : _selectedPurpose,
        'marital_status': _selectedMaritalStatus,
        'nationality': _selectedNationality,
        'region': _selectedRegion,
        'province': _selectedProvince,
        'city': _selectedCity,
        'barangay': _selectedBarangay,
      });

      setState(() {
        _isLoading = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Registration completed successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Closes the dialog
                  Navigator.pop(context); // Returns to the previous screen
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to register. Please try again.'),
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
                        const SizedBox(width: 10),
                        const Text(
                          'Forms Registration',
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
                        'Travel Details',
                        style: TextStyle(
                          color: Color(0xFF114F3A),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownWithIcon(
                      'Country of Residence',
                      Icons.public,
                      _countries,
                      _selectedCountry,
                      (value) async {
                        setState(() {
                          _selectedCountry = value;
                          _selectedRegion = null;
                          _selectedProvince = null;
                          _selectedCity = null;
                          _selectedBarangay = null;
                          _regions = [];
                          _provinces = [];
                          _cities = [];
                          _barangays = [];
                        });
                        if (value == 'Philippines') {
                          await _loadRegions();
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your country of residence';
                        }
                        return null;
                      },
                    ),
                    if (_selectedCountry == 'Philippines') ...[
                      const SizedBox(height: 10),
                      DropdownWithIcon(
                        'Region',
                        Icons.map,
                        _regions
                            .map<String>((region) => region['name'].toString())
                            .toList(),
                        _selectedRegion,
                        (value) async {
                          setState(() {
                            _selectedRegion = value;
                            _selectedProvince = null;
                            _selectedCity = null;
                            _selectedBarangay = null;
                            _provinces = [];
                            _cities = [];
                            _barangays = [];
                          });
                          await _loadProvinces(value!);
                        },
                      ),
                      DropdownWithIcon(
                        'Province',
                        Icons.location_city,
                        _provinces
                            .map<String>(
                                (province) => province['name'].toString())
                            .toList(),
                        _selectedProvince,
                        (value) async {
                          setState(() {
                            _selectedProvince = value;
                            _selectedCity = null;
                            _selectedBarangay = null;
                            _cities = [];
                            _barangays = [];
                          });
                          await _loadCities(value!);
                        },
                      ),
                      DropdownWithIcon(
                        'City / Municipality',
                        Icons.location_on,
                        _cities
                            .map<String>((city) => city['name'].toString())
                            .toList(),
                        _selectedCity,
                        (value) async {
                          setState(() {
                            _selectedCity = value;
                            _selectedBarangay = null;
                            _barangays = [];
                          });
                          await _loadBarangays(value!);
                        },
                      ),
                      DropdownWithIcon(
                        'Barangay',
                        Icons.home,
                        _barangays
                            .map<String>(
                                (barangay) => barangay['name'].toString())
                            .toList(),
                        _selectedBarangay,
                        (value) {
                          setState(() {
                            _selectedBarangay = value;
                          });
                        },
                      ),
                    ],
                    const SizedBox(height: 20),
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

// Dropdown with Icon Widget
class DropdownWithIcon extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final List<String> items;
  final String? selectedItem;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const DropdownWithIcon(
    this.hintText,
    this.iconData,
    this.items,
    this.selectedItem,
    this.onChanged, {
    super.key,
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
            child: DropdownButtonFormField<String>(
              value: selectedItem,
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child:
                      Text(item, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              dropdownColor: const Color(0xFF5CA14E),
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.white,
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}

// TextFormField with Icon Widget
class TextFormFieldWithIcon extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const TextFormFieldWithIcon(
    this.hintText,
    this.iconData,
    this.controller, {
    super.key,
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
              validator: validator,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.white),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
