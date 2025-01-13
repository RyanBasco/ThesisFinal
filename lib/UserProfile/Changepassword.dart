import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/Groups/History.dart';
import 'package:testing/Groups/Travel.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  int _selectedIndex = 4;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget page;
    switch (index) {
      case 0:
        page = UserdashboardPageState();
        break;
      case 1:
        page = QRPage();
        break;
      case 2:
        page = RegistrationPage();
        break;
      case 3:
        page = HistoryPage();
        break;
      case 4:
        page = TouristprofilePage();
        break;
      default:
        return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false,
    );
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
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFF51F643),
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 65,
        index: _selectedIndex,
        animationDuration: const Duration(milliseconds: 333),
        animationCurve: Curves.easeInOut,
        items: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home, size: 24, color: _selectedIndex == 0 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Home', style: TextStyle(color: _selectedIndex == 0 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.travel_explore, size: 24, color: _selectedIndex == 1 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Travel', style: TextStyle(color: _selectedIndex == 1 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.attach_money, size: 24, color: _selectedIndex == 2 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Transaction', style: TextStyle(color: _selectedIndex == 2 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 24, color: _selectedIndex == 3 ? const Color(0xFF27AE60) : Colors.grey),
              Text('History', style: TextStyle(color: _selectedIndex == 3 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person, size: 24, color: _selectedIndex == 4 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Profile', style: TextStyle(color: _selectedIndex == 4 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
        onTap: (index) {
          _onItemTapped(index);
        },
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
