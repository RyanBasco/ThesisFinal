import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/Wallet/Wallet.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class GenerateQR extends StatefulWidget {
  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  int _selectedIndex = 1;
  String qrData = ''; // QR code data string
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail != null) {
      try {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: userEmail)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          userData = querySnapshot.docs.first.data();

          setState(() {
            qrData = "First Name: ${userData!['first_name'] ?? ''}\n"
                "Last Name: ${userData!['last_name'] ?? ''}\n"
                "Email: $userEmail\n"
                "Birthday: ${userData!['birthday'] ?? ''}\n"
                "City: ${userData!['city'] ?? ''}\n"
                "Civil Status: ${userData!['civil_status'] ?? ''}\n"
                "Country: ${userData!['country'] ?? ''}\n"
                "Nationality: ${userData!['nationality'] ?? ''}\n"
                "Province: ${userData!['province'] ?? ''}\n"
                "Purpose of Travel: ${userData!['purpose_of_travel'] ?? ''}\n"
                "Sex: ${userData!['sex'] ?? ''}";
          });
        } else {
          print('User data not found for email: $userEmail');
          // Handle case where user data is not found
        }
      } catch (error) {
        print('Failed to fetch user data: $error');
        // Handle error as needed
      }
    } else {
      print('User email is null');
      // Handle case where user email is null
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color(0xFF2C812A),
          unselectedItemColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'My QR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Navigate back to the previous page
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.arrow_back, color: Colors.black),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Generate QR',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildWhiteContainer(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 140, // Adjusted to move the buttons higher
            left: 20,
            right: 20,
            child: _buildButton('Save', Icons.save_alt, Color(0xFF288F13), _saveQRImage),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteContainer() {
    if (userData == null) {
      return Center(child: CircularProgressIndicator());
    }

    String firstName = userData!['first_name'] ?? '';
    String lastNameInitial =
        userData!['last_name']?.toString().substring(0, 1).toUpperCase() ?? '';

    return Container(
      margin: EdgeInsets.only(top: 100, left: 20, right: 20),
      padding: EdgeInsets.all(20),
      width: 280,
      height: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          SizedBox(height: 20),
          Text(
            '$firstName $lastNameInitial.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildButton(String label, IconData icon, Color color, Function() onPressed) {
  return SizedBox(
    width: 120, // Adjust width as needed
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 14, horizontal: 16), // Adjust padding for icon and text spacing
        ),
      ),
    ),
  );
}


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on bottom navigation bar index
    switch (index) {
      case 0:
        // Check if "Home" option is tapped (handled in the same page)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserdashboardPageState()),
        );
        break;
      case 1:
        // Handle "My QR" or any custom functionality
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRPage()),
        );
        break;
      case 2:
        // Check if "Wallet" option is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage()),
        );
        break;
      case 3:
        // Check if "Profile" option is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TouristprofilePage()),
        );
        break;
    }
  }


 Future<void> _saveQRImage() async {
  try {
    final QrPainter painter = QrPainter(
      data: qrData,
      version: QrVersions.auto,
      gapless: false,
    );

    final ByteData? bytes = await painter.toImageData(200.0);

    if (bytes != null) {
      // Get the local directory path using path_provider
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/qr_image.png';

      // Write the image to the local file
      final File imageFile = File(imagePath);
      await imageFile.writeAsBytes(bytes.buffer.asUint8List());

      // Show a snackbar or toast message that the image is saved locally
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('QR image saved to local files'),
      ));
    } else {
      print('Failed to generate QR image data');
    }
  } catch (e) {
    print('Failed to save QR image: $e');
  }
}
}
