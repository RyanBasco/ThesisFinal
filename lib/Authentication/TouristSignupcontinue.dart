import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class SignupContinue extends StatefulWidget {
  const SignupContinue({super.key});

  @override
  _SignupContinueState createState() => _SignupContinueState();
}

class _SignupContinueState extends State<SignupContinue> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _specifyPurposeController =
      TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Added
  final DatabaseReference _database = FirebaseDatabase.instance.ref(); // Added

  String? _firstName; // Added
  String? _lastName;

  // Dropdown data
  List<String> _countries = [];
  List<String> _purposeOptions = [];
  List<String> _maritalStatusOptions = [
    'Single',
    'Married',
    'Widowed',
    'Divorced'
  ];
  List<String> _nationalities = [];
  List<Map<String, dynamic>> _regions = [];
  List<Map<String, dynamic>> _provinces = [];
  List<Map<String, dynamic>> _cities = [];
  List<Map<String, dynamic>> _barangays = [];

  // Selected values
  String? _selectedCountry;
  String? _selectedPurpose;
  String? _selectedRegionCode;
  String? _selectedProvinceCode;
  String? _selectedCityCode;
  String? _selectedBarangayCode;
  String? _selectedNationality;
  String? _selectedMaritalStatus;
  String? _selectedSex;

  // Loading states
  bool _isLoadingRegions = false;
  bool _isLoadingProvinces = false;
  bool _isLoadingCities = false;
  bool _isLoadingBarangays = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
    _fetchUserDetails();
  }

  @override
  void dispose() {
    _specifyPurposeController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DatabaseEvent event = await _database.child('Users/${user.uid}').once();

        // Convert the data safely
        Map<String, dynamic>? data =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        setState(() {
          _firstName = data['first_name'];
          _lastName = data['last_name'];
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        _firstName = 'Error';
        _lastName = 'Error';
      });
    }
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
        _countries = List<String>.from(countriesList); // Parse countries
        _purposeOptions = List<String>.from(
            purposeData['purpose_of_travel']); // Parse purposes
        _nationalities = List<String>.from(
            nationalityData['nationalities']); // Parse nationalities

        // Debugging output
        print('Loaded Countries: $_countries');
        print('Loaded Purpose Options: $_purposeOptions');
        print('Loaded Nationalities: $_nationalities');
      });
    } catch (e) {
      print('Error loading dropdown data: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    // Added
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = DateFormat('MMMM dd, yyyy').format(picked);
      });
    }
  }

  Future<void> _loadRegions() async {
    setState(() {
      _isLoadingRegions = true;
    });
    try {
      String regionsJson = await rootBundle.loadString('assets/region.json');
      List<dynamic> regionsList = json.decode(regionsJson);

      setState(() {
        _regions = List<Map<String, dynamic>>.from(regionsList);
      });
    } catch (e) {
      print('Error loading regions: $e');
    } finally {
      setState(() {
        _isLoadingRegions = false;
      });
    }
  }

  Future<void> _loadProvinces(String regionCode) async {
    setState(() {
      _isLoadingProvinces = true;
    });
    try {
      String provincesJson =
          await rootBundle.loadString('assets/province.json');
      List<dynamic> provincesList = json.decode(provincesJson);

      setState(() {
        _provinces = provincesList
            .where((province) => province['region_code'] == regionCode)
            .toList()
            .cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print('Error loading provinces: $e');
    } finally {
      setState(() {
        _isLoadingProvinces = false;
      });
    }
  }

  Future<void> _loadCities(String provinceCode) async {
    setState(() {
      _isLoadingCities = true;
    });
    try {
      String citiesJson = await rootBundle.loadString('assets/city.json');
      List<dynamic> citiesList = json.decode(citiesJson);

      setState(() {
        _cities = citiesList
            .where((city) => city['province_code'] == provinceCode)
            .toList()
            .cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print('Error loading cities: $e');
    } finally {
      setState(() {
        _isLoadingCities = false;
      });
    }
  }

  Future<void> _loadBarangays(String cityCode) async {
    setState(() {
      _isLoadingBarangays = true;
    });
    try {
      String barangaysJson =
          await rootBundle.loadString('assets/barangay.json');
      List<dynamic> barangaysList = json.decode(barangaysJson);

      setState(() {
        _barangays = barangaysList
            .where((barangay) => barangay['city_code'] == cityCode)
            .toList()
            .cast<Map<String, dynamic>>();

        print('Loaded Barangays: $_barangays'); // Debugging output
      });
    } catch (e) {
      print('Error loading barangays: $e');
    } finally {
      setState(() {
        _isLoadingBarangays = false;
      });
    }
  }

  Future<void> saveFormData(String userId) async {
    try {
      // Decode the codes into human-readable names
      String? decodedRegion = _regions.firstWhere(
        (region) => region['region_code'] == _selectedRegionCode,
        orElse: () => {'region_name': null},
      )['region_name'];

      String? decodedProvince = _provinces.firstWhere(
        (province) => province['province_code'] == _selectedProvinceCode,
        orElse: () => {'province_name': null},
      )['province_name'];

      String? decodedCity = _cities.firstWhere(
        (city) => city['city_code'] == _selectedCityCode,
        orElse: () => {'city_name': null},
      )['city_name'];

      String? decodedBarangay = _barangays.firstWhere(
        (barangay) => barangay['brgy_code'] == _selectedBarangayCode,
        orElse: () => {'brgy_name': null},
      )['brgy_name'];

      // Save form data to Firebase Realtime Database
      await _database.child('Forms/$userId').set({
        'birthday': _birthdayController.text,
        'sex': _selectedSex,
        'contact': _contactController.text,
        'country': _selectedCountry,
        'region': _selectedCountry == 'Philippines' ? decodedRegion : null,
        'province': _selectedCountry == 'Philippines' ? decodedProvince : null,
        'city': _selectedCountry == 'Philippines' ? decodedCity : null,
        'barangay': _selectedCountry == 'Philippines' ? decodedBarangay : null,
        'purpose_of_travel': _selectedPurpose,
        'purpose_details':
            _selectedPurpose == 'Other' ? _specifyPurposeController.text : null,
        'marital_status': _selectedMaritalStatus,
        'nationality': _selectedNationality,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error saving form data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting form: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
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
                        const SizedBox(width: 60),
                        const Text(
                          'Form Registration',
                          style: TextStyle(
                            color: Color(0xFF114F3A),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_firstName != null && _lastName != null) ...[
                      Text(
                        'Full Name: $_firstName $_lastName', // Combined first and last name
                        style: const TextStyle(
                          color: Color(0xFF114F3A),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        // Added
                        'Birthday',
                        style: TextStyle(
                          color: Color(0xFF114F3A),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10), // Added
                      GestureDetector(
                        // Added
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _birthdayController,
                            decoration: InputDecoration(
                              hintText: 'Select Birthday',
                              filled: true,
                              fillColor: const Color(0xFF5CA14E),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: const TextStyle(color: Colors.white),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a birthday';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      // Sex dropdown
                      const SizedBox(height: 20), // Added
                      const Text(
                        // Added
                        'Sex',
                        style: TextStyle(
                          color: Color(0xFF114F3A),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10), // Added
                      Container(
                        // Added
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5CA14E),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedSex,
                          items: const [
                            DropdownMenuItem(
                                value: 'Male', child: Text('Male')),
                            DropdownMenuItem(
                                value: 'Female', child: Text('Female')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedSex = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Select Sex',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                          dropdownColor: const Color(0xFF5CA14E),
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your sex';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Contact Field
                      const Text(
                        'Contact',
                        style: TextStyle(
                          color: Color(0xFF114F3A),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _contactController,
                        decoration: InputDecoration(
                          hintText: 'Enter Contact Number',
                          filled: true,
                          fillColor: const Color(0xFF5CA14E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: const TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),

                      // Country Dropdown
                      const Text(
                        'Country of Residence',
                        style: TextStyle(
                          color: Color(0xFF114F3A),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5CA14E),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedCountry,
                          items: _countries.map((country) {
                            return DropdownMenuItem<String>(
                              value: country,
                              child: Text(country,
                                  style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            setState(() {
                              _selectedCountry = value;

                              // Reset dependent dropdowns
                              _selectedRegionCode = null;
                              _selectedProvinceCode = null;
                              _selectedCityCode = null;
                              _selectedBarangayCode = null;
                              _regions = [];
                              _provinces = [];
                              _cities = [];
                              _barangays = [];
                            });

                            if (value == 'Philippines') {
                              await _loadRegions(); // Load regions if "Philippines" is selected
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Select Country',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                          dropdownColor: const Color(0xFF5CA14E),
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a country';
                            }
                            return null;
                          },
                        ),
                      ),

                      if (_selectedCountry == 'Philippines') ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5CA14E),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: _isLoadingRegions
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : DropdownButtonFormField<String>(
                                  value: _selectedRegionCode,
                                  items: _regions.map((region) {
                                    return DropdownMenuItem<String>(
                                      value: region['region_code'],
                                      child: Text(region['region_name'],
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    );
                                  }).toList(),
                                  onChanged: (value) async {
                                    setState(() {
                                      _selectedRegionCode = value;

                                      // Reset dependent dropdowns
                                      _selectedProvinceCode = null;
                                      _selectedCityCode = null;
                                      _selectedBarangayCode = null;
                                      _provinces = [];
                                      _cities = [];
                                      _barangays = [];
                                    });

                                    if (value != null) {
                                      await _loadProvinces(value);
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Select Region',
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: InputBorder.none,
                                  ),
                                  dropdownColor: const Color(0xFF5CA14E),
                                  style: const TextStyle(color: Colors.white),
                                  iconEnabledColor: Colors.white,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a region';
                                    }
                                    return null;
                                  },
                                ),
                        ),

                        // Province Dropdown
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5CA14E),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: _isLoadingProvinces
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : DropdownButtonFormField<String>(
                                  value: _selectedProvinceCode,
                                  items: _provinces.map((province) {
                                    return DropdownMenuItem<String>(
                                      value: province['province_code'],
                                      child: Text(province['province_name'],
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    );
                                  }).toList(),
                                  onChanged: (value) async {
                                    setState(() {
                                      _selectedProvinceCode = value;

                                      // Reset dependent dropdowns
                                      _selectedCityCode = null;
                                      _selectedBarangayCode = null;
                                      _cities = [];
                                      _barangays = [];
                                    });

                                    if (value != null) {
                                      await _loadCities(value);
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Select Province',
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: InputBorder.none,
                                  ),
                                  dropdownColor: const Color(0xFF5CA14E),
                                  style: const TextStyle(color: Colors.white),
                                  iconEnabledColor: Colors.white,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a province';
                                    }
                                    return null;
                                  },
                                ),
                        ),

                        // City Dropdown
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5CA14E),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: _isLoadingCities
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : DropdownButtonFormField<String>(
                                  value: _selectedCityCode,
                                  items: _cities.map((city) {
                                    return DropdownMenuItem<String>(
                                      value: city['city_code'],
                                      child: Text(city['city_name'],
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    );
                                  }).toList(),
                                  onChanged: (value) async {
                                    setState(() {
                                      _selectedCityCode = value;

                                      // Reset dependent dropdowns
                                      _selectedBarangayCode = null;
                                      _barangays = [];
                                    });

                                    if (value != null) {
                                      await _loadBarangays(value);
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Select City / Municipality',
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: InputBorder.none,
                                  ),
                                  dropdownColor: const Color(0xFF5CA14E),
                                  style: const TextStyle(color: Colors.white),
                                  iconEnabledColor: Colors.white,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a city';
                                    }
                                    return null;
                                  },
                                ),
                        ),

                        // Barangay Dropdown
                        const SizedBox(height: 20),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5CA14E),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: _isLoadingBarangays
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : DropdownButtonFormField<String>(
                                    value: _selectedBarangayCode,
                                    items: _barangays
                                        .map((barangay) {
                                          // Ensure you're using the correct keys: "brgy_code" and "brgy_name"
                                          if (barangay['brgy_code'] != null &&
                                              barangay['brgy_name'] != null) {
                                            return DropdownMenuItem<String>(
                                              value: barangay[
                                                  'brgy_code'], // Correct key for brgy_code
                                              child: Text(
                                                barangay[
                                                    'brgy_name'], // Correct key for brgy_name
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            );
                                          } else {
                                            return null; // Skip items with null values
                                          }
                                        })
                                        .where((item) => item != null)
                                        .cast<
                                            DropdownMenuItem<
                                                String>>() // Explicitly cast to List<DropdownMenuItem<String>>
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedBarangayCode = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Select Barangay',
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: InputBorder.none,
                                    ),
                                    dropdownColor: const Color(0xFF5CA14E),
                                    style: const TextStyle(color: Colors.white),
                                    iconEnabledColor: Colors.white,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a barangay';
                                      }
                                      return null;
                                    },
                                  ))
                      ],

                      const SizedBox(height: 20),

                      // Purpose of Travel Dropdown
                      const Text(
                        'Purpose of Travel',
                        style: TextStyle(
                          color: Color(0xFF114F3A),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5CA14E),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedPurpose,
                          items: _purposeOptions.map((purpose) {
                            return DropdownMenuItem<String>(
                              value: purpose,
                              child: Text(purpose,
                                  style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPurpose = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Select Purpose',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                          dropdownColor: const Color(0xFF5CA14E),
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a purpose';
                            }
                            return null;
                          },
                        ),
                      ),

                      if (_selectedPurpose == 'Other') ...[
                        const SizedBox(height: 10),
                        const Text(
                          'Please Specify',
                          style: TextStyle(
                            color: Color(0xFF114F3A),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _specifyPurposeController,
                          decoration: InputDecoration(
                            hintText: 'Enter purpose',
                            filled: true,
                            fillColor: const Color(0xFF5CA14E),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            hintStyle: const TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please specify your purpose';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Marital Status Dropdown
                      const Text(
                        'Marital Status',
                        style: TextStyle(
                          color: Color(0xFF114F3A),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5CA14E),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedMaritalStatus,
                          items: _maritalStatusOptions.map((status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status,
                                  style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMaritalStatus = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Select Marital Status',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                          dropdownColor: const Color(0xFF5CA14E),
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select marital status';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Nationality Dropdown
                      const Text(
                        'Nationality',
                        style: TextStyle(
                          color: Color(0xFF114F3A),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5CA14E),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
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
                              print(
                                  'Selected Nationality: $_selectedNationality'); // Debug
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Select Nationality',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
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
                      const SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    setState(() {
                                      _isLoading = true; // Start loading
                                    });
                                    try {
                                      String userId = FirebaseAuth
                                              .instance.currentUser?.uid ??
                                          'unknown_user';
                                      await saveFormData(userId);
                                      setState(() {
                                        _isLoading = false; // Stop loading
                                      });

                                      // Show success dialog
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Success'),
                                            content: const Text(
                                                'Your form has been registered successfully.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close dialog
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserdashboardPageState(),
                                                    ),
                                                  );
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } catch (e) {
                                      setState(() {
                                        _isLoading =
                                            false; // Stop loading in case of error
                                      });
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Error'),
                                            content: Text(
                                                'Failed to submit form: $e'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close dialog
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isLoading
                                ? Colors.grey
                                : const Color(0xFF288F13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(200, 50),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ]),
            ),
          ),
        ),
      ),
    ));
  }
}
