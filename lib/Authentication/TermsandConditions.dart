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
                  'We value your privacy and are committed to protecting your personal data. This Privacy Policy outlines how we collect, use, and protect your information when you use the APP.',
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
                        'We collect personal information to provide, personalize, and improve our services. The types of information we collect include:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Personal Identification Information: Such as your name, email address, contact information, and date of birth, which are necessary for account creation, customer support, and enhancing user experience.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '2. Feedback and Communication: If you choose to provide feedback or communicate with us, we collect and store those messages to respond to your inquiries, improve our services, and ensure a better user experience.',
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
                        'We use your personal information to enhance your experience with our app, provide necessary services, and improve our offerings. Specifically, we use the information we collect for the following purposes:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Improvement and Development: To analyze usage patterns, gather feedback, and make data-driven improvements to our app, products, and services.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '2. Security and Fraud Prevention: To monitor and enhance security, detect potential fraud, and ensure the safety of all users.',
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
                        'We prioritize your privacy and are committed to handling your data with care. We only share your personal information in the following cases:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Service Providers: We may share your data with trusted third-party providers who assist us in delivering our services, such as cloud storage, customer support, or data analysis. These providers have access only to the information necessary to perform their tasks and are bound by confidentiality agreements.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '2. With Your Consent: We may share your information with third parties when you give us explicit permission to do so.',
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
                        'We are committed to ensuring the security of your personal information and protecting it from unauthorized access, disclosure, alteration, or destruction. To achieve this, we implement a combination of technical, administrative, and physical safeguards:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Encryption: All sensitive data transmitted through our app is encrypted both in transit and at rest, helping to prevent unauthorized access.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '2. Access Controls: Access to your personal information is restricted to authorized personnel only, and we employ strict access controls and authentication protocols to maintain data privacy.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                       SizedBox(height: 10),
                      Text(
                        '3. User Responsibility: While we implement security measures, we encourage you to help keep your information secure by choosing strong passwords, keeping your credentials confidential, and logging out after using the app on shared devices.',
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
                        'We respect your privacy rights and strive to provide you with control over your personal information. Depending on your location and applicable laws, you may have the following rights:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Access: You can request access to the personal information we hold about you and receive a copy in a commonly used format.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '2. Correction: If your information is inaccurate or incomplete, you have the right to request that we correct or update it.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '3. Restrict Processing: You have the right to ask us to restrict the processing of your data in certain circumstances, such as if you contest the accuracy of the data.',
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
                        'We may update this Privacy Policy periodically to reflect changes in our practices, legal requirements, or for other operational reasons. When we make significant changes, we will notify you by posting a prominent notice within the app or by other appropriate means, such as email.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'We encourage you to review this policy regularly to stay informed about how we are protecting your personal information. Your continued use of our app following any updates constitutes your acceptance of the revised Privacy Policy.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10,)
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
                        'By using this app, you agree to comply with the following guidelines to ensure a safe, respectful, and lawful experience for all users:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Authorized Use: You are permitted to use this app only for its intended purposes as outlined in these Terms and Conditions. Unauthorized use of the app or its content is strictly prohibited.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                       SizedBox(height: 10),
                      Text(
                        '2. Account Responsibility: You are responsible for maintaining the confidentiality of your account details and for all activities that occur under your account. Notify us immediately if you suspect any unauthorized access or security breach.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                       SizedBox(height: 10),
                      Text(
                        '3. Accurate Information: You agree to provide accurate, current, and complete information when creating an account or interacting with app features.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10,)
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
                        'As a user of this app, you agree to the following responsibilities to ensure a safe, compliant, and enjoyable experience for all:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Provide Accurate Information: You are responsible for ensuring that all information you provide within the app is accurate, complete, and up-to-date.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                       SizedBox(height: 10),
                      Text(
                        '2. Protect Your Account: Safeguard your account information, including your password, and avoid sharing it with others. You are accountable for all actions taken under your account. ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10,)
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
                        'Our app may include QR code features designed to streamline interactions, verify identity, and enhance user experience. By using the QR code feature, you agree to the following guidelines:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Authorized Use Only: QR codes generated or provided by this app are for personal use only and must not be shared, duplicated, or tampered with for unauthorized purposes.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '2. Responsibility for Use: You are responsible for QR codes generated by your account. Any actions taken using your QR code are considered your responsibility.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10,)
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
                        'All content, features, and functionality within this app—including but not limited to text, graphics, logos, icons, images, videos, software, and any other material—are the exclusive property of [App Name] and its licensors, protected by copyright, trademark, patent, trade secret, and other intellectual property laws.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Intellectual Property Infringement: We respect the intellectual property rights of others and expect our users to do the same. If you believe that any content in the app infringes upon your intellectual property rights, please contact us with the relevant details.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                       SizedBox(height: 10),
                      Text(
                        '2. User-Generated Content: By submitting content to the app (e.g., reviews, comments, or feedback), you grant us a worldwide, non-exclusive, royalty-free license to use, display, reproduce, modify, or distribute your content as part of the app or our marketing materials.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10,)
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
                        'This app and all its features are provided on an "as-is" and "as-available" basis without any warranties of any kind, either express or implied. By using the app, you acknowledge and agree to the following:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Service Availability: We do not guarantee that the app will be available, uninterrupted, secure, or error-free at all times. Downtime may occur due to maintenance, updates, technical issues, or other reasons beyond our control.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        '2. No Guarantees: We make no warranties or guarantees regarding the accuracy, completeness, or reliability of any content, information, or features provided through the app.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 10,)
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
