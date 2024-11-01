import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:testing/EstablishmentDetails/Details.dart';
import 'package:testing/TouristDashboard/Notifications.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/Wallet/Wallet.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';

class UserdashboardPageState extends StatefulWidget {
  const UserdashboardPageState({super.key});

  @override
  _UserdashboardPageState createState() => _UserdashboardPageState();
}

class _UserdashboardPageState extends State<UserdashboardPageState> {
  int _selectedIndex = 0;
  String _firstName = '';
  String _lastName = '';
  final TextEditingController _searchController = TextEditingController();
  final List<bool> _isBookmarked = [];
  List<Map<String, dynamic>> _establishments = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchEstablishments();
  }

  void _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('Users');
        DataSnapshot snapshot = await usersRef.get();

        // Look for a user with a matching email (case insensitive)
        for (var userSnapshot in snapshot.children) {
          Map<dynamic, dynamic>? userData = userSnapshot.value as Map<dynamic, dynamic>?;
          String emailFromDatabase = userData?['email'] ?? '';

          if (emailFromDatabase.toLowerCase() == user.email!.toLowerCase()) {
            setState(() {
              _firstName = userData?['first_name'] ?? '';
              _lastName = userData?['last_name'] ?? '';
            });
            break;
          }
        }

        // Fetch bookmarks
        DatabaseReference bookmarksRef = FirebaseDatabase.instance.ref().child('Users').child(user.uid).child('Bookmarks');
        DataSnapshot bookmarksSnapshot = await bookmarksRef.get();

        _isBookmarked.clear();
        for (var _ in _establishments) {
          _isBookmarked.add(false); // Default to not bookmarked
        }
        for (var bookmark in bookmarksSnapshot.children) {
          String bookmarkKey = bookmark.key ?? '';
          int index = int.tryParse(bookmarkKey.split('_')[1] ?? '') ?? -1;
          if (index >= 0 && index < _isBookmarked.length) {
            _isBookmarked[index] = true; // Mark as bookmarked
          }
        }

        setState(() {}); // Refresh UI
      } catch (error) {
        print('Failed to fetch user data: $error');
      }
    }
  }

  void _fetchEstablishments() async {
    try {
      DatabaseReference establishmentsRef = FirebaseDatabase.instance.ref().child('establishments');
      DataSnapshot snapshot = await establishmentsRef.get();

      setState(() {
        _establishments = [];
        for (var establishmentSnapshot in snapshot.children) {
          Map<dynamic, dynamic>? establishmentData = establishmentSnapshot.value as Map<dynamic, dynamic>?;
          if (establishmentData != null) {
            _establishments.add(Map<String, dynamic>.from(establishmentData));
          }
        }
        _isBookmarked.addAll(List.filled(_establishments.length, false));
      });
    } catch (error) {
      print('Failed to fetch establishments: $error');
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
          MaterialPageRoute(builder: (context) => const UserdashboardPageState()),
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
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TouristprofilePage()),
        );
        break;
    }
  }

  void _toggleBookmark(int index) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DatabaseReference bookmarkRef = FirebaseDatabase.instance.ref()
            .child('Users').child(user.uid).child('Bookmarks').child('bookmark_$index');

        if (_isBookmarked[index]) {
          await bookmarkRef.remove();
        } else {
          String title = _establishments[index]['establishmentName'] ?? 'Unknown';
          await bookmarkRef.set({
            'title': title,
            'location': 'San Miguel, Jordan',
          });
        }

        setState(() {
          _isBookmarked[index] = !_isBookmarked[index];
        });
      } catch (error) {
        print('Failed to update bookmark: $error');
      }
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
            stops: [0.0, 0.5, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome, $_firstName $_lastName',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications, size: 30),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Notifications()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.black),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 10),
                child: Text(
                  "Let's Explore",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF2C812A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Search Results',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF2C812A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              for (int i = 0; i < _establishments.length; i++)
                _buildResultBoxWithInitial(
                  _establishments[i]['establishmentName'],
                  i == 0,
                  i,
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultBoxWithInitial(String resultText, bool isFirstBox, int index) {
    String firstInitial = resultText.isNotEmpty ? resultText[0].toUpperCase() : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Stack(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      firstInitial,
                      style: const TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                resultText,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isFirstBox ? const Color(0xFF288F13) : Colors.green,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _toggleBookmark(index);
                              },
                              child: Icon(
                                Icons.bookmark,
                                color: _isBookmarked.length > index && _isBookmarked[index] ? Colors.yellow : Colors.grey,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.green),
                            SizedBox(width: 5),
                            Text(
                              'San Miguel, Jordan',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: GestureDetector(
              onTap: () {
                // Navigate to DetailsPage when the arrow is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(establishmentName: resultText), // Pass the name here
                  ),
                );
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2C812A), width: 2),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: 330 * 3.14159 / 180, // Angle for the arrow icon
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF2C812A),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}