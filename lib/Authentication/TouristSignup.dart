import 'dart:convert'; // For JSON decoding
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

  DateTime? _selectedDate;
  String? _selectedSex;
  String? _selectedCivilStatus;
  String? _selectedNationality;

  List<CountryCode> _countryCodes = [];
  CountryCode? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _initializeCountryCodes();
  }

  void _initializeCountryCodes() {
  _countryCodes = [
  CountryCode(name: "Philippines", code: "+63", abbreviation: "PH", maxDigits: 10),
  CountryCode(name: "Afghanistan", code: "+93", abbreviation: "AF", maxDigits: 9),
  CountryCode(name: "Albania", code: "+355", abbreviation: "AL", maxDigits: 9),
  CountryCode(name: "Algeria", code: "+213", abbreviation: "DZ", maxDigits: 9),
  CountryCode(name: "Andorra", code: "+376", abbreviation: "AD", maxDigits: 6),
  CountryCode(name: "Angola", code: "+244", abbreviation: "AO", maxDigits: 9),
  CountryCode(name: "Argentina", code: "+54", abbreviation: "AR", maxDigits: 10),
  CountryCode(name: "Armenia", code: "+374", abbreviation: "AM", maxDigits: 8),
  CountryCode(name: "Australia", code: "+61", abbreviation: "AU", maxDigits: 9),
  CountryCode(name: "Austria", code: "+43", abbreviation: "AT", maxDigits: 10),
  CountryCode(name: "Azerbaijan", code: "+994", abbreviation: "AZ", maxDigits: 9),
  CountryCode(name: "Bahamas", code: "+1-242", abbreviation: "BS", maxDigits: 10),
  CountryCode(name: "Bahrain", code: "+973", abbreviation: "BH", maxDigits: 8),
  CountryCode(name: "Bangladesh", code: "+880", abbreviation: "BD", maxDigits: 10),
  CountryCode(name: "Belarus", code: "+375", abbreviation: "BY", maxDigits: 9),
  CountryCode(name: "Belgium", code: "+32", abbreviation: "BE", maxDigits: 9),
  CountryCode(name: "Belize", code: "+501", abbreviation: "BZ", maxDigits: 7),
  CountryCode(name: "Benin", code: "+229", abbreviation: "BJ", maxDigits: 8),
  CountryCode(name: "Bhutan", code: "+975", abbreviation: "BT", maxDigits: 8),
  CountryCode(name: "Bolivia", code: "+591", abbreviation: "BO", maxDigits: 8),
  CountryCode(name: "Bosnia and Herzegovina", code: "+387", abbreviation: "BA", maxDigits: 8),
  CountryCode(name: "Botswana", code: "+267", abbreviation: "BW", maxDigits: 7),
  CountryCode(name: "Brazil", code: "+55", abbreviation: "BR", maxDigits: 11),
  CountryCode(name: "Brunei", code: "+673", abbreviation: "BN", maxDigits: 7),
  CountryCode(name: "Bulgaria", code: "+359", abbreviation: "BG", maxDigits: 9),
  CountryCode(name: "Burkina Faso", code: "+226", abbreviation: "BF", maxDigits: 8),
  CountryCode(name: "Burundi", code: "+257", abbreviation: "BI", maxDigits: 8),
  CountryCode(name: "Cambodia", code: "+855", abbreviation: "KH", maxDigits: 9),
  CountryCode(name: "Cameroon", code: "+237", abbreviation: "CM", maxDigits: 9),
  CountryCode(name: "Canada", code: "+1", abbreviation: "CA", maxDigits: 10),
  CountryCode(name: "Cape Verde", code: "+238", abbreviation: "CV", maxDigits: 7),
  CountryCode(name: "Central African Republic", code: "+236", abbreviation: "CF", maxDigits: 8),
  CountryCode(name: "Chad", code: "+235", abbreviation: "TD", maxDigits: 8),
  CountryCode(name: "Chile", code: "+56", abbreviation: "CL", maxDigits: 9),
  CountryCode(name: "China", code: "+86", abbreviation: "CN", maxDigits: 11),
  CountryCode(name: "Colombia", code: "+57", abbreviation: "CO", maxDigits: 10),
  CountryCode(name: "Comoros", code: "+269", abbreviation: "KM", maxDigits: 7),
  CountryCode(name: "Congo", code: "+242", abbreviation: "CG", maxDigits: 9),
  CountryCode(name: "Congo, Democratic Republic", code: "+243", abbreviation: "CD", maxDigits: 9),
  CountryCode(name: "Costa Rica", code: "+506", abbreviation: "CR", maxDigits: 8),
  CountryCode(name: "Croatia", code: "+385", abbreviation: "HR", maxDigits: 9),
  CountryCode(name: "Cuba", code: "+53", abbreviation: "CU", maxDigits: 8),
  CountryCode(name: "Cyprus", code: "+357", abbreviation: "CY", maxDigits: 8),
  CountryCode(name: "Czech Republic", code: "+420", abbreviation: "CZ", maxDigits: 9),
  CountryCode(name: "Denmark", code: "+45", abbreviation: "DK", maxDigits: 8),
  CountryCode(name: "Djibouti", code: "+253", abbreviation: "DJ", maxDigits: 8),
  CountryCode(name: "Dominica", code: "+1-767", abbreviation: "DM", maxDigits: 10),
  CountryCode(name: "Dominican Republic", code: "+1-809", abbreviation: "DO", maxDigits: 10),
  CountryCode(name: "Ecuador", code: "+593", abbreviation: "EC", maxDigits: 9),
  CountryCode(name: "Egypt", code: "+20", abbreviation: "EG", maxDigits: 10),
  CountryCode(name: "El Salvador", code: "+503", abbreviation: "SV", maxDigits: 8),
  CountryCode(name: "Equatorial Guinea", code: "+240", abbreviation: "GQ", maxDigits: 9),
  CountryCode(name: "Eritrea", code: "+291", abbreviation: "ER", maxDigits: 7),
  CountryCode(name: "Estonia", code: "+372", abbreviation: "EE", maxDigits: 8),
  CountryCode(name: "Eswatini", code: "+268", abbreviation: "SZ", maxDigits: 7),
  CountryCode(name: "Ethiopia", code: "+251", abbreviation: "ET", maxDigits: 9),
  CountryCode(name: "Fiji", code: "+679", abbreviation: "FJ", maxDigits: 7),
  CountryCode(name: "Finland", code: "+358", abbreviation: "FI", maxDigits: 10),
  CountryCode(name: "France", code: "+33", abbreviation: "FR", maxDigits: 9),
  CountryCode(name: "Gabon", code: "+241", abbreviation: "GA", maxDigits: 7),
  CountryCode(name: "Gambia", code: "+220", abbreviation: "GM", maxDigits: 7),
  CountryCode(name: "Georgia", code: "+995", abbreviation: "GE", maxDigits: 9),
  CountryCode(name: "Germany", code: "+49", abbreviation: "DE", maxDigits: 11),
  CountryCode(name: "Ghana", code: "+233", abbreviation: "GH", maxDigits: 9),
  CountryCode(name: "Greece", code: "+30", abbreviation: "GR", maxDigits: 10),
  CountryCode(name: "Grenada", code: "+1-473", abbreviation: "GD", maxDigits: 10),
  CountryCode(name: "Guatemala", code: "+502", abbreviation: "GT", maxDigits: 8),
  CountryCode(name: "Guinea", code: "+224", abbreviation: "GN", maxDigits: 9),
  CountryCode(name: "Guinea-Bissau", code: "+245", abbreviation: "GW", maxDigits: 7),
  CountryCode(name: "Guyana", code: "+592", abbreviation: "GY", maxDigits: 7),
  CountryCode(name: "Haiti", code: "+509", abbreviation: "HT", maxDigits: 8),
  CountryCode(name: "Honduras", code: "+504", abbreviation: "HN", maxDigits: 8),
  CountryCode(name: "Hungary", code: "+36", abbreviation: "HU", maxDigits: 9),
  CountryCode(name: "Iceland", code: "+354", abbreviation: "IS", maxDigits: 7),
  CountryCode(name: "India", code: "+91", abbreviation: "IN", maxDigits: 10),
  CountryCode(name: "Indonesia", code: "+62", abbreviation: "ID", maxDigits: 10),
  CountryCode(name: "Iran", code: "+98", abbreviation: "IR", maxDigits: 10),
  CountryCode(name: "Iraq", code: "+964", abbreviation: "IQ", maxDigits: 10),
  CountryCode(name: "Ireland", code: "+353", abbreviation: "IE", maxDigits: 9),
  CountryCode(name: "Israel", code: "+972", abbreviation: "IL", maxDigits: 9),
  CountryCode(name: "Italy", code: "+39", abbreviation: "IT", maxDigits: 10),
  CountryCode(name: "Jamaica", code: "+1-876", abbreviation: "JM", maxDigits: 10),
  CountryCode(name: "Japan", code: "+81", abbreviation: "JP", maxDigits: 10),
  CountryCode(name: "Jordan", code: "+962", abbreviation: "JO", maxDigits: 9),
  CountryCode(name: "Kazakhstan", code: "+7", abbreviation: "KZ", maxDigits: 10),
  CountryCode(name: "Kenya", code: "+254", abbreviation: "KE", maxDigits: 10),
  CountryCode(name: "South Korea", code: "+82", abbreviation: "KR", maxDigits: 10),
  CountryCode(name: "Kuwait", code: "+965", abbreviation: "KW", maxDigits: 8),
  CountryCode(name: "Kyrgyzstan", code: "+996", abbreviation: "KG", maxDigits: 9),
  CountryCode(name: "Laos", code: "+856", abbreviation: "LA", maxDigits: 9),
  CountryCode(name: "Latvia", code: "+371", abbreviation: "LV", maxDigits: 8),
  CountryCode(name: "Lebanon", code: "+961", abbreviation: "LB", maxDigits: 8),
  CountryCode(name: "Lesotho", code: "+266", abbreviation: "LS", maxDigits: 8),
  CountryCode(name: "Liberia", code: "+231", abbreviation: "LR", maxDigits: 8),
  CountryCode(name: "Libya", code: "+218", abbreviation: "LY", maxDigits: 9),
  CountryCode(name: "Liechtenstein", code: "+423", abbreviation: "LI", maxDigits: 9),
  CountryCode(name: "Lithuania", code: "+370", abbreviation: "LT", maxDigits: 8),
  CountryCode(name: "Luxembourg", code: "+352", abbreviation: "LU", maxDigits: 9),
  CountryCode(name: "Madagascar", code: "+261", abbreviation: "MG", maxDigits: 9),
  CountryCode(name: "Malawi", code: "+265", abbreviation: "MW", maxDigits: 9),
  CountryCode(name: "Malaysia", code: "+60", abbreviation: "MY", maxDigits: 10),
  CountryCode(name: "Maldives", code: "+960", abbreviation: "MV", maxDigits: 7),
  CountryCode(name: "Mali", code: "+223", abbreviation: "ML", maxDigits: 8),
  CountryCode(name: "Malta", code: "+356", abbreviation: "MT", maxDigits: 8),
  CountryCode(name: "Marshall Islands", code: "+692", abbreviation: "MH", maxDigits: 7),
  CountryCode(name: "Mauritania", code: "+222", abbreviation: "MR", maxDigits: 8),
  CountryCode(name: "Mauritius", code: "+230", abbreviation: "MU", maxDigits: 8),
  CountryCode(name: "Mexico", code: "+52", abbreviation: "MX", maxDigits: 10),
  CountryCode(name: "Micronesia", code: "+691", abbreviation: "FM", maxDigits: 7),
  CountryCode(name: "Moldova", code: "+373", abbreviation: "MD", maxDigits: 8),
  CountryCode(name: "Monaco", code: "+377", abbreviation: "MC", maxDigits: 9),
  CountryCode(name: "Mongolia", code: "+976", abbreviation: "MN", maxDigits: 8),
  CountryCode(name: "Montenegro", code: "+382", abbreviation: "ME", maxDigits: 8),
  CountryCode(name: "Morocco", code: "+212", abbreviation: "MA", maxDigits: 9),
  CountryCode(name: "Mozambique", code: "+258", abbreviation: "MZ", maxDigits: 9),
  CountryCode(name: "Myanmar", code: "+95", abbreviation: "MM", maxDigits: 10),
  CountryCode(name: "Namibia", code: "+264", abbreviation: "NA", maxDigits: 9),
  CountryCode(name: "Nepal", code: "+977", abbreviation: "NP", maxDigits: 10),
  CountryCode(name: "Netherlands", code: "+31", abbreviation: "NL", maxDigits: 9),
  CountryCode(name: "New Zealand", code: "+64", abbreviation: "NZ", maxDigits: 9),
  CountryCode(name: "Nicaragua", code: "+505", abbreviation: "NI", maxDigits: 8),
  CountryCode(name: "Niger", code: "+227", abbreviation: "NE", maxDigits: 8),
  CountryCode(name: "Nigeria", code: "+234", abbreviation: "NG", maxDigits: 10),
  CountryCode(name: "North Macedonia", code: "+389", abbreviation: "MK", maxDigits: 8),
  CountryCode(name: "Norway", code: "+47", abbreviation: "NO", maxDigits: 8),
  CountryCode(name: "Oman", code: "+968", abbreviation: "OM", maxDigits: 8),
  CountryCode(name: "Pakistan", code: "+92", abbreviation: "PK", maxDigits: 10),
  CountryCode(name: "Palau", code: "+680", abbreviation: "PW", maxDigits: 7),
  CountryCode(name: "Panama", code: "+507", abbreviation: "PA", maxDigits: 8),
  CountryCode(name: "Papua New Guinea", code: "+675", abbreviation: "PG", maxDigits: 8),
  CountryCode(name: "Paraguay", code: "+595", abbreviation: "PY", maxDigits: 9),
  CountryCode(name: "Peru", code: "+51", abbreviation: "PE", maxDigits: 9),
  CountryCode(name: "Poland", code: "+48", abbreviation: "PL", maxDigits: 9),
  CountryCode(name: "Portugal", code: "+351", abbreviation: "PT", maxDigits: 9),
  CountryCode(name: "Qatar", code: "+974", abbreviation: "QA", maxDigits: 8),
  CountryCode(name: "Romania", code: "+40", abbreviation: "RO", maxDigits: 9),
  CountryCode(name: "Russia", code: "+7", abbreviation: "RU", maxDigits: 10),
  CountryCode(name: "Rwanda", code: "+250", abbreviation: "RW", maxDigits: 9),
  CountryCode(name: "Saudi Arabia", code: "+966", abbreviation: "SA", maxDigits: 9),
  CountryCode(name: "Senegal", code: "+221", abbreviation: "SN", maxDigits: 9),
  CountryCode(name: "Serbia", code: "+381", abbreviation: "RS", maxDigits: 9),
  CountryCode(name: "Sierra Leone", code: "+232", abbreviation: "SL", maxDigits: 8),
  CountryCode(name: "Singapore", code: "+65", abbreviation: "SG", maxDigits: 8),
  CountryCode(name: "Slovakia", code: "+421", abbreviation: "SK", maxDigits: 9),
  CountryCode(name: "Slovenia", code: "+386", abbreviation: "SI", maxDigits: 9),
  CountryCode(name: "South Africa", code: "+27", abbreviation: "ZA", maxDigits: 9),
  CountryCode(name: "South Korea", code: "+82", abbreviation: "KR", maxDigits: 10),
  CountryCode(name: "Spain", code: "+34", abbreviation: "ES", maxDigits: 9),
  CountryCode(name: "Sri Lanka", code: "+94", abbreviation: "LK", maxDigits: 9),
  CountryCode(name: "Sudan", code: "+249", abbreviation: "SD", maxDigits: 9),
  CountryCode(name: "Sweden", code: "+46", abbreviation: "SE", maxDigits: 9),
  CountryCode(name: "Switzerland", code: "+41", abbreviation: "CH", maxDigits: 9),
  CountryCode(name: "Syria", code: "+963", abbreviation: "SY", maxDigits: 9),
  CountryCode(name: "Taiwan", code: "+886", abbreviation: "TW", maxDigits: 9),
  CountryCode(name: "Tanzania", code: "+255", abbreviation: "TZ", maxDigits: 9),
  CountryCode(name: "Thailand", code: "+66", abbreviation: "TH", maxDigits: 9),
  CountryCode(name: "Turkey", code: "+90", abbreviation: "TR", maxDigits: 10),
  CountryCode(name: "Uganda", code: "+256", abbreviation: "UG", maxDigits: 9),
  CountryCode(name: "Ukraine", code: "+380", abbreviation: "UA", maxDigits: 9),
  CountryCode(name: "United Arab Emirates", code: "+971", abbreviation: "AE", maxDigits: 9),
  CountryCode(name: "United Kingdom", code: "+44", abbreviation: "GB", maxDigits: 10),
  CountryCode(name: "United States", code: "+1", abbreviation: "US", maxDigits: 10),
  CountryCode(name: "Uruguay", code: "+598", abbreviation: "UY", maxDigits: 9),
  CountryCode(name: "Uzbekistan", code: "+998", abbreviation: "UZ", maxDigits: 9),
  CountryCode(name: "Vanuatu", code: "+678", abbreviation: "VU", maxDigits: 7),
  CountryCode(name: "Vatican City", code: "+379", abbreviation: "VA", maxDigits: 10),
  CountryCode(name: "Venezuela", code: "+58", abbreviation: "VE", maxDigits: 10),
  CountryCode(name: "Vietnam", code: "+84", abbreviation: "VN", maxDigits: 9),
  CountryCode(name: "Yemen", code: "+967", abbreviation: "YE", maxDigits: 9),
  CountryCode(name: "Zambia", code: "+260", abbreviation: "ZM", maxDigits: 9),
  CountryCode(name: "Zimbabwe", code: "+263", abbreviation: "ZW", maxDigits: 9),
    ];
    // Set default selected country
    _selectedCountry = _countryCodes.firstWhere((country) => country.name == "Philippines");
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
                        text: _selectedDate != null
                            ? DateFormat.yMMMMd().format(_selectedDate!)
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
                            if (value == null || value.isEmpty) {
                              return 'Please enter contact number';
                            }
                            if (value.length < (_selectedCountry?.maxDigits ?? 10)) {
                              return 'Contact number must be ${_selectedCountry?.maxDigits} digits';
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupContinue(
                                lastName: _lastNameController.text,
                                firstName: _firstNameController.text,
                                email: _emailController.text,
                                selectedNationality: _selectedNationality ?? '',
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
