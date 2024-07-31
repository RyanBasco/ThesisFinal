import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/Wallet/Wallet.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:intl/intl.dart';


class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _firstName = '';
  String _lastName = '';
  String _birthday = '';
  String _email = '';
  String _contactNumber = ''; // New field for storing contact number

  int _selectedIndex = 3; // Set default index to 3 for Profile

  bool _isEditing = false; // Toggle for editing mode

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.size > 0) {
          var userData = querySnapshot.docs.first.data();
          setState(() {
            _firstName = userData['first_name'] ?? '';
            _lastName = userData['last_name'] ?? '';
            _birthday = userData['birthday'] ?? '';
            _email = user.email ?? '';
            _contactNumber = userData['contact_number'] ?? '';

            _nameController.text = '$_firstName $_lastName';
            _birthdayController.text = _birthday;
            _emailController.text = _email;
            _contactNumberController.text = _contactNumber;
          });
        } else {
          print('User data not found for email: ${user.email}');
        }
      } catch (error) {
        print('Failed to fetch user data: $error');
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserdashboardPageState()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage()),
        );
        break;
      // case 3: // No need to navigate to the same page (Profile)
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.size > 0) {
          var userDoc = querySnapshot.docs.first.reference;
          var nameParts = _nameController.text.split(' ');
          var firstName = nameParts.length > 0 ? nameParts[0] : '';
          var lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

          await userDoc.update({
            'first_name': firstName,
            'last_name': lastName,
            'birthday': _birthdayController.text,
            'contact_number': _contactNumberController.text,
          });

          setState(() {
            _firstName = firstName;
            _lastName = lastName;
            _birthday = _birthdayController.text;
            _contactNumber = _contactNumberController.text;
            _isEditing = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')),
          );
        } else {
          print('User data not found for email: ${user.email}');
        }
      } catch (error) {
        print('Failed to update user data: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile. Please try again.')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2101),
  );
  if (picked != null && picked != DateTime.now()) {
    setState(() {
      _birthdayController.text = DateFormat('MMMM d, yyyy').format(picked);
    });
  }
}

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    bool enabled = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: 260,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.grey[200], // Light grey background
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 18),
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: Colors.grey[700], // Grey [600] text color
                fontSize: 18,
              ),
              enabled: enabled,
              textAlign: TextAlign.center, // Centering the text
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              readOnly: onTap != null, // Make the text field read-only if onTap is provided
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEEFFA9),
              Color(0xFFDBFF4C),
              Color(0xFF51F643),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.15, 0.54, 1.0],
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
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Profile',
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
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 300,
                  height: 640, // Increased height to accommodate new items
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 55,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10, // Adjusted to align with the profile icon
                        bottom: 490,
                        left: 70, // Adjust position to bottom right
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                     Positioned(
                        top: 60, // Adjusted for better positioning
                        right: 60,
                        child: Text(
                          'Upload Image',
                          style: TextStyle(
                            color: Color(0xFF2C812A), // Set color to 2C812A
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 120,
                        left: 20,
                        child: _buildTextField(
                          labelText: 'Name',
                          controller: _nameController,
                          enabled: _isEditing,
                        ),
                      ),
                      Positioned(
                        top: 220,
                        left: 20,
                        child: _buildTextField(
                          labelText: 'Birthday',
                          controller: _birthdayController,
                          enabled: _isEditing,
                          onTap: () => _selectDate(context), // Show calendar picker
                        ),
                      ),
                      Positioned(
                        top: 320,
                        left: 20,
                        child: _buildTextField(
                          labelText: 'Email',
                          controller: _emailController,
                          enabled: _isEditing,
                        ),
                      ),
                      Positioned(
                        top: 420,
                        left: 20,
                        child: _buildTextField(
                          labelText: 'Contact Number',
                          controller: _contactNumberController,
                          enabled: _isEditing,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: _toggleEdit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2C812A), // Green color
                                foregroundColor: Colors.white, // White text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(_isEditing ? 'Cancel' : 'Edit'),
                            ),
                            if (_isEditing)
                              ElevatedButton(
                                onPressed: _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF2C812A), // Green color
                                  foregroundColor: Colors.white, // White text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text('Save'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
