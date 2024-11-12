import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:testing/EstablishmentDetails/Details.dart';
import 'package:testing/TouristDashboard/Notifications.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';

class UserdashboardPageState extends StatefulWidget {
  const UserdashboardPageState({super.key});

  @override
  _UserdashboardPageState createState() => _UserdashboardPageState();
}

class _UserdashboardPageState extends State<UserdashboardPageState> {
  int _selectedIndex = 0;
  int? _selectedCategoryIndex;
  int? _selectedLocationIndex;
  String _firstName = '';
  String _lastName = '';
  final TextEditingController _searchController = TextEditingController();
  final List<bool> _isBookmarked = [];
  List<Map<String, dynamic>> _establishments = [];
  List<Map<String, dynamic>> _filteredEstablishments = [];

  Map<String, String> establishmentImageUrls = {};
  Map<String, String> barangayMap = {};
  Map<String, String> cityMap = {};

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Accommodation', 'icon': Icons.hotel},
    {'name': 'Food and Beverages', 'icon': Icons.restaurant_menu},
    {'name': 'Transportation', 'icon': Icons.directions_car},
    {'name': 'Attractions and Activities', 'icon': Icons.local_activity},
    {'name': 'Shopping', 'icon': Icons.shopping_bag},
    {'name': 'Entertainment', 'icon': Icons.theater_comedy},
    {'name': 'Wellness and Spa Services', 'icon': Icons.spa},
    {'name': 'Adventure and Outdoor Activities', 'icon': Icons.terrain},
    {'name': 'Travel Insurance', 'icon': Icons.shield},
    {'name': 'Local Tours and Guides', 'icon': Icons.tour},
  ];

  final List<String> _locations = [
    "Buenavista",
    "Jordan",
    "San Lorenzo",
    "Sibunag",
    "Nueva Valencia",
  ];

  final Map<String, String> cityNameMapping = {
    "Jordan": "Jordan (Capital)",
  };

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterEstablishments);
    _fetchUserData();
    _fetchEstablishments();
    _loadLocationNames();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterEstablishments);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLocationNames() async {
    final String barangayData =
        await rootBundle.loadString('assets/barangay.json');
    final String cityData = await rootBundle.loadString('assets/city.json');

    final List<dynamic> barangays = json.decode(barangayData);
    final List<dynamic> cities = json.decode(cityData);

    barangayMap = {for (var b in barangays) b['brgy_code']: b['brgy_name']};
    cityMap = {for (var c in cities) c['city_code']: c['city_name']};

    setState(() {});
  }

  void _filterEstablishments() {
    String query = _searchController.text.toLowerCase();
    String? selectedCategory = _selectedCategoryIndex != null
        ? _categories[_selectedCategoryIndex!]['name']
        : null;

    setState(() {
      _filteredEstablishments = _establishments.where((establishment) {
        String name = establishment['establishmentName']?.toLowerCase() ?? '';
        bool matchesQuery = name.contains(query);

        bool matchesCategory = selectedCategory == null ||
            (establishment['Services'] != null &&
                establishment['Services'] is List &&
                (establishment['Services'] as List<dynamic>)
                    .contains(selectedCategory));

        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DatabaseReference usersRef =
            FirebaseDatabase.instance.ref().child('Users');
        DataSnapshot snapshot = await usersRef.get();

        for (var userSnapshot in snapshot.children) {
          Map<dynamic, dynamic>? userData =
              userSnapshot.value as Map<dynamic, dynamic>?;
          String emailFromDatabase = userData?['email'] ?? '';

          if (emailFromDatabase.toLowerCase() == user.email!.toLowerCase()) {
            setState(() {
              _firstName = userData?['first_name'] ?? '';
              _lastName = userData?['last_name'] ?? '';
            });
            break;
          }
        }

        DatabaseReference bookmarksRef = FirebaseDatabase.instance
            .ref()
            .child('Users')
            .child(user.uid)
            .child('Bookmarks');
        DataSnapshot bookmarksSnapshot = await bookmarksRef.get();

        _isBookmarked.clear();
        for (var _ in _establishments) {
          _isBookmarked.add(false);
        }
        for (var bookmark in bookmarksSnapshot.children) {
          String bookmarkKey = bookmark.key ?? '';
          int index = int.tryParse(bookmarkKey.split('_')[1] ?? '') ?? -1;
          if (index >= 0 && index < _isBookmarked.length) {
            _isBookmarked[index] = true;
          }
        }

        setState(() {});
      } catch (error) {
        print('Failed to fetch user data: $error');
      }
    }
  }

  Future<void> _fetchEstablishments() async {
    try {
      DatabaseReference establishmentsRef =
          FirebaseDatabase.instance.ref().child('establishments');
      DataSnapshot snapshot = await establishmentsRef.get();

      if (snapshot.exists) {
        List<Map<String, dynamic>> establishmentsList = [];

        for (var establishmentSnapshot in snapshot.children) {
          Map<String, dynamic> establishmentData =
              Map<String, dynamic>.from(establishmentSnapshot.value as Map);
          String establishmentId = establishmentSnapshot.key ?? '';

          // Add establishment data with ID to the list
          establishmentsList.add({
            ...establishmentData,
            'establishmentId': establishmentId,
          });

          // Fetch image for each establishment
          try {
            String imagePath =
                'Establishment/$establishmentId/profile_image/latest_image.jpg';
            String downloadUrl = await FirebaseStorage.instance
                .ref()
                .child(imagePath)
                .getDownloadURL();
            establishmentImageUrls[establishmentId] = downloadUrl;
          } catch (e) {
            print("No image found for $establishmentId: $e");
          }
        }

        setState(() {
          _establishments = establishmentsList;
          _filteredEstablishments = _establishments;
        });
      }
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
          MaterialPageRoute(
              builder: (context) => const UserdashboardPageState()),
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
        DatabaseReference bookmarkRef = FirebaseDatabase.instance
            .ref()
            .child('Users')
            .child(user.uid)
            .child('Bookmarks')
            .child('bookmark_$index');

        String barangayCode = _establishments[index]['barangay'] ?? 'Unknown';
        String cityCode = _establishments[index]['city'] ?? 'Unknown';
        String barangay = barangayMap[barangayCode] ?? 'Unknown';
        String city = cityMap[cityCode] ?? 'Unknown';

        if (_isBookmarked[index]) {
          await bookmarkRef.remove();
          print('Bookmark removed');
        } else {
          String title =
              _establishments[index]['establishmentName'] ?? 'Unknown';
          await bookmarkRef.set({
            'title': title,
            'location': '$barangay, $city',
          });
          print('Bookmark added');
        }

        setState(() {
          _isBookmarked[index] = !_isBookmarked[index];
        });
      } catch (error) {
        print('Failed to update bookmark: $error');
      }
    }
  }

  void _onLocationSelected(int index) {
    setState(() {
      _selectedLocationIndex = index;
    });
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    _filterEstablishments();
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications, size: 30),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Notifications()),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(3, (index) {
                        return GestureDetector(
                          onTap: () => _onLocationSelected(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _selectedLocationIndex == index
                                  ? const Color(0xFF288F13)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              _locations[index],
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedLocationIndex == index
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(2, (index) {
                        int locationIndex = index + 3;
                        return GestureDetector(
                          onTap: () => _onLocationSelected(locationIndex),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _selectedLocationIndex == locationIndex
                                  ? const Color(0xFF288F13)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              _locations[locationIndex],
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedLocationIndex == locationIndex
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 0, bottom: 5),
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF2C812A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> category = _categories[index];
                    bool isSelected = _selectedCategoryIndex == index;

                    return GestureDetector(
                      onTap: () {
                        _onCategorySelected(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF288F13)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              category['icon'],
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF2C812A),
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                category['name'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  'Search Results',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF2C812A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 0),
              for (int i = 0; i < _filteredEstablishments.length; i++)
                if ((_selectedLocationIndex == null ||
                    cityMap[_filteredEstablishments[i]['city']] ==
                        (cityNameMapping[_locations[_selectedLocationIndex!]] ??
                            _locations[_selectedLocationIndex!])))
                  _buildResultBoxWithInitial(
                    _filteredEstablishments[i]['establishmentName'],
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

  Widget _buildResultBoxWithInitial(
      String resultText, bool isFirstBox, int index) {
    String docId = _filteredEstablishments[index]['establishmentId'] ?? '';
    String firstInitial =
        resultText.isNotEmpty ? resultText[0].toUpperCase() : '';
    String barangayCode =
        _filteredEstablishments[index]['barangay'] ?? 'Unknown';
    String cityCode = _filteredEstablishments[index]['city'] ?? 'Unknown';
    String barangay = barangayMap[barangayCode] ?? 'Unknown';
    String city = cityMap[cityCode] ?? 'Unknown';

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
                    child: establishmentImageUrls.containsKey(docId)
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            child: Image.network(
                              establishmentImageUrls[docId]!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : Text(
                            firstInitial,
                            style: const TextStyle(
                              fontSize: 50,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isFirstBox
                                      ? const Color(0xFF288F13)
                                      : Colors.green,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _toggleBookmark(index);
                              },
                              child: Icon(
                                Icons.bookmark,
                                color: _isBookmarked.length > index &&
                                        _isBookmarked[index]
                                    ? Colors.yellow
                                    : Colors.grey,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.green, size: 16),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '$barangay, $city',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
          // Green arrow icon
          Positioned(
            right: 10,
            bottom: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(
                      establishmentName: resultText, // Pass the name here
                      barangay: barangayCode, // Pass barangay here
                      city: cityCode, // Pass city here
                      establishmentId: docId, // Pass the establishment ID here
                    ),
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
                    angle: 330 * 3.14159 / 180,
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF2C812A),
                      size: 18,
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
