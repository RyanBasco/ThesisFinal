import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:testing/EstablishmentDetails/Details.dart';
import 'package:testing/TouristDashboard/Notifications.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/Wallet/Wallet.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';


class UserdashboardPageState extends StatefulWidget {
  @override
  _UserdashboardPageState createState() => _UserdashboardPageState();
}

class _UserdashboardPageState extends State<UserdashboardPageState> {
  int _selectedIndex = 0;
  String _firstName = '';
  String _lastName = '';
  TextEditingController _searchController = TextEditingController();
  int _selectedBarIndex = -1; // Track selected bar index, -1 for none
  int _selectedCategoryIndex = -1; // Track selected category index, -1 for none
  List<bool> _isBookmarked = [false, false, false, false, false]; // Track bookmark states

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
            _firstName = userData['first_name'] ?? ''; // Safe access using ??
            _lastName = userData['last_name'] ?? ''; // Safe access using ??
          });
        } else {
          print('User data not found for email: ${user.email}');
          // Handle case where user data is not found
        }
      } catch (error) {
        print('Failed to fetch user data: $error');
        // Handle error as needed
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
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TouristprofilePage()),
        );
        break;
    }
  }

  void _onBarSelected(int index) {
    setState(() {
      _selectedBarIndex = index;
    });
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
  }

  void _toggleBookmark(int index) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      var bookmarkRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Bookmarks')
          .doc('bookmark_$index'); // Ensure unique ID for each bookmark

      if (_isBookmarked[index]) {
        // Remove bookmark
        await bookmarkRef.delete();
      } else {
        // Add bookmark
        String title;
        String imagePath;

        switch (index) {
          case 0:
            title = 'JL Pension House';
            imagePath = 'assets/Pension.png';
            break;
          case 1:
            title = 'JM Backpackers Hotel';
            imagePath = 'assets/windmill.png';
            break;
          case 2:
            title = 'Mancol Oasis Lodge';
            imagePath = 'assets/Mancol.png';
            break;
          case 3:
            title = 'Sidewalkers Pension House';
            imagePath = 'assets/Sidewalkers.png';
            break;
          case 4:
            title = 'Zemkamps Chalet';
            imagePath = 'assets/Tree.png';
            break;
          default:
            title = 'Unknown';
            imagePath = '';
            break;
        }

        await bookmarkRef.set({
          'title': title,
          'imagePath': imagePath,
          'location': 'San Miguel, Jordan',
        });
      }

      setState(() {
        _isBookmarked[index] = !_isBookmarked[index];
      });
    } catch (error) {
      print('Failed to update bookmark: $error');
      // Handle error as needed
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
            stops: [0.0, 0.5, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome, $_firstName $_lastName',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications, size: 30),
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
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.black),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
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
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Text(
                  "Let's Explore",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF2C812A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRoundedBarWithShadow('Buenavista', 0),
                    _buildRoundedBarWithShadow('Jordan', 1),
                    _buildRoundedBarWithShadow('San Lorenzo', 2),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRoundedBarWithShadow('Sibunag', 3),
                    _buildRoundedBarWithShadow('Nueva Valencia', 4),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF2C812A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
             Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    // Row for Accommodation and Food & Drinks
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust padding as needed
                            child: _buildCategoryBar('Accommodation', 0),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust padding as needed
                            child: _buildCategoryBar('Food & Drinks', 1),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Adjust spacing as needed
                    // Souvenir Shop with reduced width
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust padding as needed
                      child: Container(
                        width: 200, // Set a specific width for the Souvenir Shop container
                        child: _buildCategoryBar('Souvenir Shop', 2),
                      ),
                    ),
                  ],
                ),
              ),

             SizedBox(height: 20), // Added space before Search Results
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Search Results',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF2C812A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                  SizedBox(height: 10),
                  _buildResultBoxWithImage('JL Pension House', 'assets/Pension.png', true, 0),
                  _buildResultBoxWithImage('JM Backpackers Hotel', 'assets/windmill.png', false, 1),
                  SizedBox(height: 10), // Added space
                Column(
                  children: [
                    _buildResultBoxWithImage('Mancol Oasis Lodge', 'assets/Mancol.png', false, 2),
                    SizedBox(height: 10), // Space between containers
                    _buildResultBoxWithImage('Sidewalkers Pension House', 'assets/Sidewalkers.png', false, 3),
                    SizedBox(height: 10), // Space between containers
                    _buildResultBoxWithImage('Zemkamps Chalet', 'assets/Tree.png', false, 4),
                  ],
                ),
                SizedBox(height: 20), // Added space after the last container
            ],
        ),
        )
      )
    );
  }

  Widget _buildRoundedBarWithShadow(String text, int index) {
  return GestureDetector(
    onTap: () => _onBarSelected(index),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: _selectedBarIndex == index ? Color(0xFF288F13) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: _selectedBarIndex == index ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}


  Widget _buildCategoryBar(String text, int index) {
  return GestureDetector(
    onTap: () => _onCategorySelected(index),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: _selectedCategoryIndex == index ? Color(0xFF288F13) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: _selectedCategoryIndex == index ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}


Widget _buildResultBoxWithImage(String resultText, String imagePath, bool isFirstBox, int index) {
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
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
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
                                color: isFirstBox ? Color(0xFF288F13) : Colors.green,
                              ),
                              maxLines: 2, // Allow text to wrap to the next line
                              overflow: TextOverflow.ellipsis, // Display ellipsis if text overflows
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
                      SizedBox(height: 5),
                      Row(
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
              if (isFirstBox) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailsPage()),
                );
              }
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF2C812A), width: 2),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Transform.rotate(
                  angle: 330 * 3.14159 / 180, // Rotate 45 degrees
                  child: Icon(
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
