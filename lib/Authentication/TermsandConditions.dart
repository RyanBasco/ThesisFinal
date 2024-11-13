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
  bool _isTerminationExpanded = false;
  bool _isGoverningLawExpanded = false;
  bool _isEntireAgreementExpanded = false;

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
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.5,
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      TextSpan(
                        text:
                            'We value your privacy and are committed to protecting your personal data. This Privacy Policy outlines how we collect, use, and protect your information when you use ',
                      ),
                      TextSpan(
                        text: 'Isla G.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Personal Information: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                            TextSpan(
                              text:
                                  'When you register for Isla G, we collect personal information such as your name, age, gender, nationality, email address, travel documents (e.g., passport, visa), and travel history.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Itinerary and Spending Data: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                            TextSpan(
                              text:
                                  'We collect details about your itinerary transactions, including destinations, activities, accommodations, transportation modes, and spending records.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'QR Code Data: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                            TextSpan(
                              text:
                                  'Information related to QR codes generated by tourists and scanned by establishments.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
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
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'To Provide and Improve Services: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                            TextSpan(
                              text:
                                  'We use your information to provide the services offered by Isla G, including itinerary transactions and spending tracking.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Data Analysis: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                            TextSpan(
                              text:
                                  'We analyze data to understand tourism spending patterns and generate reports for improving tourism services.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Communication: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                            TextSpan(
                              text:
                                  'We use your information to communicate with you regarding your account, validation status, and other relevant updates.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Compliance and Legal Obligations: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                            TextSpan(
                              text:
                                  'We may use your information to comply with legal obligations and enforce our terms and conditions.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
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
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'With Establishments: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Your QR code, which is only limited to your full name, is shared with registered tourism-related establishments for transaction validation purposes.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'With PEDO and Port Officers: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Your personal information and transactions may be accessed by the officers to ensure compliance with local regulations.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Legal Requirements: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'We may disclose your information if required by law or in response to legal processes.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
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
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, alteration, disclosure, or destruction.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Data Retention: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'We retain your personal data for as long as necessary to provide our services, comply with legal obligations, resolve disputes, and enforce our policies.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
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
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Access and Update: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'You have the right to access and update your personal information through Isla G.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Delete: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'You may request the deletion of your account and personal data by contacting us.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Object: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'You may object to the processing of your personal data under certain circumstances.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
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
                        'We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting the new Privacy Policy on Isla G and updating the date at the top.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'If you have any questions or concerns about this Privacy Policy, please contact us at [islag@gmail.com].',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.5,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 30),
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
                  'Welcome to Isla G. By accessing and using Isla G, you agree to comply with and be bound by these Terms and Conditions.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.5,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                buildExpandableSection(
                  title: 'Use of Isla G',
                  isExpanded: _isUseAppExpanded,
                  onPressed: () {
                    setState(() {
                      _isUseAppExpanded = !_isUseAppExpanded;
                    });
                  },
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Eligibility: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'You must be at least 18 years old to use Isla G. By using the app, you represent and warrant that you meet this eligibility requirement.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Account Registration: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'To access certain features of Isla G, you must register for an account. You agree to provide accurate and complete information during registration and to update your information as necessary.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Prohibited Conduct: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'You agree not to use Isla G for any unlawful or prohibited activities, including but not limited to violating intellectual property rights, transmitting harmful software, or engaging in fraudulent activities.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'User Responsibilities',
                  isExpanded: _isUserResponsibilitiesExpanded,
                  onPressed: () {
                    setState(() {
                      _isUserResponsibilitiesExpanded =
                          !_isUserResponsibilitiesExpanded;
                    });
                  },
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Security: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Compliance: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'You agree to comply with all applicable laws and regulations when using Isla G.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
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
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Generation and Scanning: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Tourists can generate QR codes for their profiles and itineraries, which establishments can scan for spending record purposes. You agree to use this feature responsibly and in accordance with Isla G’s guidelines.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'Intellectual Property',
                  isExpanded: _isIntellectualPropertyExpanded,
                  onPressed: () {
                    setState(() {
                      _isIntellectualPropertyExpanded =
                          !_isIntellectualPropertyExpanded;
                    });
                  },
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Ownership: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'All content, features, and functionalities of Isla G are owned by our licensors and are protected by intellectual property laws.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'License: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'We grant you a limited, non-exclusive, non-transferable license to use Isla G for its intended purposes.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'Disclaimers and Limitation of Liability',
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
                        'No Warranty: Isla G is provided "as is" and "as available" without any warranties of any kind, either express or implied.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Limitation of Liability: To the maximum extent permitted by law, we are not liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses resulting from your use of Isla G.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'Termination',
                  isExpanded: _isGoverningLawExpanded,
                  onPressed: () {
                    setState(() {
                      _isGoverningLawExpanded = !_isGoverningLawExpanded;
                    });
                  },
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Termination by You: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'You may terminate your account at any time by contacting us.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Termination by Us: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text:
                                  'We may suspend or terminate your access to Isla G if you violate these Terms and Conditions or for any other reason at our discretion.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'Changes to These Terms',
                  isExpanded: _isTerminationExpanded,
                  onPressed: () {
                    setState(() {
                      _isTerminationExpanded = !_isTerminationExpanded;
                    });
                  },
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'We may modify these Terms and Conditions from time to time. We will notify you of any significant changes by posting the new Terms and Conditions on Isla G and updating the date at the top.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 7.5),
                buildExpandableSection(
                  title: 'Governing Law',
                  isExpanded: _isEntireAgreementExpanded,
                  onPressed: () {
                    setState(() {
                      _isEntireAgreementExpanded = !_isEntireAgreementExpanded;
                    });
                  },
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'These Terms and Conditions are governed by the laws of the Philippines, without regard to its conflict of law principles.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'If you have any questions or concerns about these Terms and Conditions, please contact us at [islag@gmail.com].',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.5,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 30,)
              ]
            )
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
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
