import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:testing/Authentication/TouristLogin.dart';
import 'package:testing/Groups/Groups.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:testing/UserProfile/Changepassword.dart';
import 'package:testing/UserProfile/Editprofile.dart';
import 'package:testing/UserProfile/HelpCenter.dart';
import 'package:testing/UserProfile/Mybookmarks.dart';
import 'package:testing/UserProfile/PrivacyPolicy.dart';
import 'package:firebase_database/firebase_database.dart';

class TouristprofilePage extends StatefulWidget {
  const TouristprofilePage({super.key});

  @override
  _TouristprofilePageState createState() => _TouristprofilePageState();
}

class _TouristprofilePageState extends State<TouristprofilePage> {
  String _firstName = '';
  String _lastName = '';
  String _userId = '';
  String? _profileImageUrl;
  int _selectedIndex = 4; // Set initial index to 'Profile'

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetch user name from Firebase Realtime Database
        DatabaseReference userRef = FirebaseDatabase.instance.ref('Users/${user.uid}');
        DatabaseEvent event = await userRef.once();

        if (event.snapshot.exists) {
          var userData = event.snapshot.value as Map;
          setState(() {
            _firstName = userData['first_name'] ?? '';
            _lastName = userData['last_name'] ?? '';
          });
        } else {
          print('User data not found for UID: ${user.uid}');
        }

        // Try to fetch profile image URL from Firebase Storage
        String filePath = 'UserProfile/${user.uid}/profile_image/latest_image.jpg';
        Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
        String downloadUrl = await storageRef.getDownloadURL();
        setState(() {
          _profileImageUrl = downloadUrl;
        });
      } catch (error) {
        print('Failed to fetch user data or image: $error');
      }
    }
  }

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
      page = GroupPage();
      break;
    case 2:
      page = QRPage();
      break;
    case 3:
      page = RegistrationPage();
      break;
    case 4:
      page = TouristprofilePage();
      break;
    default:
      return;
  }

  // Navigate to the new page without animation (direct transition)
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
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
        icon: Icon(Icons.group),
        label: 'Groups',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.attach_money),
        label: 'Transactions',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: 'History',
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
        decoration: const BoxDecoration(
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
              const Padding(
                padding:  EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                child: Row(
                  children: [
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
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 300,
                  height: 550,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 20,
                        left: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 45,
                          child: _profileImageUrl == null
                              ? const Icon(Icons.person, color: Colors.white, size: 55)
                              : ClipOval(
                                  child: Image.network(
                                    _profileImageUrl!,
                                    fit: BoxFit.cover,
                                    width: 110,
                                    height: 110,
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 125,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$_firstName $_lastName',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 100,
                        left: 20,
                        bottom: 340,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfile()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2C812A),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 25),
                              const Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 92),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 180,
                        left: 20,
                        bottom: 310,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2C812A),
                                ),
                                child: const Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 25),
                              const Text(
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 40),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 230,
                        left: 20,
                        bottom: 250,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BookmarkPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2C812A),
                                ),
                                child: const Icon(
                                  Icons.bookmark,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 25),
                              const Text(
                                'My Bookmarks',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 63),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 270,
                        left: 20,
                        bottom: 170,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Helpcenter()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2C812A),
                                ),
                                child: const Icon(
                                  Icons.help_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 25),
                              const Text(
                                'Help Center',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 85),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 340,
                        left: 20,
                        bottom: 130,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Privacypolicy()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2C812A),
                                ),
                                child: const Icon(
                                  Icons.privacy_tip_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 25),
                              const Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 70),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 415,
                        left: 20,
                        child: GestureDetector(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPageScreen()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 25),
                              const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 120),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
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
