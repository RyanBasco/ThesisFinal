import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Handle "Home"
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserdashboardPageState()),
        );
        break;
      case 1:
        // Handle "My QR"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRPage()),
        );
        break;
      case 2:
        // Handle "Wallet"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage()),
        );
        break;
      // case 3: // No need to navigate to the same page (Profile)
    }
  }

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _togglePasswordVisibility(String field) {
    setState(() {
      switch (field) {
        case 'current':
          _obscureCurrentPassword = !_obscureCurrentPassword;
          break;
        case 'new':
          _obscureNewPassword = !_obscureNewPassword;
          break;
        case 'confirm':
          _obscureConfirmPassword = !_obscureConfirmPassword;
          break;
      }
    });
  }

  void _changePassword() async {
    // Ensure new password and confirm password match
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Re-authenticate user
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text,
        );

        await user.reauthenticateWithCredential(credential);

        // Update password in Firebase Authentication
        await user.updatePassword(_newPasswordController.text);

        // Update password in Firestore (optional, you can remove this if not needed)
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({'password': _newPasswordController.text});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully.')),
        );

        // Clear text fields
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } catch (error) {
        print('Failed to update password: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update password. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensure the background color is white
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF2C812A),
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'My QR',
          ),
          BottomNavigationBarItem(
             icon: Icon(Icons.attach_money),
             label: 'Expense Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Navigate back to the previous page
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Change Password',
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
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C812A),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        labelText: 'Current Password',
                        controller: _currentPasswordController,
                        obscureText: _obscureCurrentPassword,
                        toggleVisibility: () {
                          _togglePasswordVisibility('current');
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        labelText: 'New Password',
                        controller: _newPasswordController,
                        obscureText: _obscureNewPassword,
                        toggleVisibility: () {
                          _togglePasswordVisibility('new');
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        labelText: 'Confirm Password',
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        toggleVisibility: () {
                          _togglePasswordVisibility('confirm');
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Save Password'),
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

  Widget _buildInputField({
    required String labelText,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: toggleVisibility,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
