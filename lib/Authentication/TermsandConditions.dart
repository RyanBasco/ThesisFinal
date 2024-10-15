import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool _isInformationExpanded = false;
  bool _isUsageExpanded = false;
  bool _isDataSharingExpanded = false;
  bool _isSecurityExpanded = false;
  bool _isRightsExpanded = false;
  bool _isChangesExpanded = false;
  bool _isUseAppExpanded = false;
  bool _isUserResponsibilitiesExpanded = false;
  bool _isQRCodeUseExpanded = false;
  bool _isIntellectualPropertyExpanded = false;
  bool _isNoWarrantyExpanded = false;

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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
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
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'We value your privacy and are committed to protecting your personal data. This Privacy Policy outlines how we collect, use, and protect your information when you use the [APP NAME].',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.5,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                buildExpandableSection(
                  title: 'Information We Collect',
                  isExpanded: _isInformationExpanded,
                  onPressed: () {
                    setState(() {
                      _isInformationExpanded = !_isInformationExpanded;
                    });
                  },
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detailed information about the data we collect.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Additional details can go here as needed.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'How We Use Your Information',
                  isExpanded: _isUsageExpanded,
                  onPressed: () {
                    setState(() {
                      _isUsageExpanded = !_isUsageExpanded;
                    });
                  },
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Information about how we use the collected data.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'More details on usage can be added here.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'Data Sharing and Disclosure',
                  isExpanded: _isDataSharingExpanded,
                  onPressed: () {
                    setState(() {
                      _isDataSharingExpanded = !_isDataSharingExpanded;
                    });
                  },
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details on how we share and disclose your data.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Information on sharing practices can go here.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'Data Security',
                  isExpanded: _isSecurityExpanded,
                  onPressed: () {
                    setState(() {
                      _isSecurityExpanded = !_isSecurityExpanded;
                    });
                  },
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Information about how we secure your data.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Security measures can be detailed here.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'Your Rights',
                  isExpanded: _isRightsExpanded,
                  onPressed: () {
                    setState(() {
                      _isRightsExpanded = !_isRightsExpanded;
                    });
                  },
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Information about your rights regarding your data.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Details on user rights can be included here.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'Changes to This Privacy Policy',
                  isExpanded: _isChangesExpanded,
                  onPressed: () {
                    setState(() {
                      _isChangesExpanded = !_isChangesExpanded;
                    });
                  },
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details about updates and changes to the privacy policy.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'How changes are communicated can go here.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome to the [APP NAME]. By accessing and using the app, you agree to comply with and be bound by these Terms and Conditions.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.5,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                buildExpandableSection(
                  title: 'Use of the App',
                  isExpanded: _isUseAppExpanded,
                  onPressed: () {
                    setState(() {
                      _isUseAppExpanded = !_isUseAppExpanded;
                    });
                  },
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details about how to use the app responsibly.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'More details can be added here.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'User Responsibilities',
                  isExpanded: _isUserResponsibilitiesExpanded,
                  onPressed: () {
                    setState(() {
                      _isUserResponsibilitiesExpanded = !_isUserResponsibilitiesExpanded;
                    });
                  },
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Information about user responsibilities.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Additional details on user responsibilities can go here.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'QR Code Use',
                  isExpanded: _isQRCodeUseExpanded,
                  onPressed: () {
                    setState(() {
                      _isQRCodeUseExpanded = !_isQRCodeUseExpanded;
                    });
                  },
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Information about the use of QR codes within the app.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Additional details on QR code usage can go here.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'Intellectual Property',
                  isExpanded: _isIntellectualPropertyExpanded,
                  onPressed: () {
                    setState(() {
                      _isIntellectualPropertyExpanded = !_isIntellectualPropertyExpanded;
                    });
                  },
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Information about the intellectual property rights.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Additional details on intellectual property can go here.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'No Warranty',
                  isExpanded: _isNoWarrantyExpanded,
                  onPressed: () {
                    setState(() {
                      _isNoWarrantyExpanded = !_isNoWarrantyExpanded;
                    });
                  },
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Information about the no warranty policy.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Additional details on the no warranty policy can go here.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14.5,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onPressed,
    required Widget content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: const Color(0xFF288F13), // Bar color
          child: Column(
            children: [
              GestureDetector(
                onTap: onPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.remove : Icons.add,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isExpanded ? null : 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: content,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
