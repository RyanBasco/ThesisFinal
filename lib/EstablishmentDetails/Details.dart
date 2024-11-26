import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:testing/EstablishmentDetails/Directions.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class DetailsPage extends StatefulWidget {
  final String establishmentName;
  final String barangay;
  final String city;
  final String establishmentId;

  const DetailsPage({
    super.key,
    required this.establishmentName,
    required this.barangay,
    required this.city,
    required this.establishmentId,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int _selectedIndex = 0;
  bool _isBookmarked = false;
  String? barangayName;
  String? cityName;
  String? profileImageUrl;
  String aboutText = 'Loading...';
  double averageRating = 0.0;
  int totalReviews = 0;

  @override
  void initState() {
    super.initState();
    _loadLocationNames();
    _fetchEstablishmentImage();
    _fetchAboutText();
    _fetchAverageRating();
  }

  Future<void> _fetchEstablishmentImage() async {
    try {
      String filePath =
          'Establishment/${widget.establishmentId}/profile_image/latest_image.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
      String downloadUrl = await storageRef.getDownloadURL();
      setState(() {
        profileImageUrl = downloadUrl;
      });
    } catch (e) {
      print('Error fetching profile image: $e');
    }
  }

  Future<void> _fetchAboutText() async {
    try {
      DatabaseReference dbRef =
          FirebaseDatabase.instance.ref('establishments/${widget.establishmentId}');
      final snapshot = await dbRef.child('About').get();

      if (snapshot.exists) {
        setState(() {
          aboutText = snapshot.value as String;
        });
      } else {
        print('No About text found for this establishment.');
      }
    } catch (e) {
      print('Error fetching About text: $e');
    }
  }

  Future<void> _fetchAverageRating() async {
    DatabaseReference reviewsRef =
        FirebaseDatabase.instance.ref().child('reviews');
    DataSnapshot snapshot = await reviewsRef.get();
    int totalStars = 0;
    int count = 0;

    if (snapshot.exists) {
      Map data = snapshot.value as Map;

      data.forEach((key, value) {
        final review = Map<String, dynamic>.from(value);
        if (review['establishment_id'] == widget.establishmentId) {
          int rating = review['rating'];
          totalStars += rating;
          count++;
        }
      });

      setState(() {
        totalReviews = count;
        averageRating = count > 0 ? totalStars / count : 0.0;
      });
    }
  }

  Future<void> _loadLocationNames() async {
    final String barangayData = await rootBundle.loadString('assets/barangay.json');
    final String cityData = await rootBundle.loadString('assets/city.json');

    final List<dynamic> barangays = json.decode(barangayData);
    final List<dynamic> cities = json.decode(cityData);

    final barangay = barangays.firstWhere(
      (b) => b['brgy_code'].toString() == widget.barangay,
      orElse: () {
        print('No matching barangay found for code: ${widget.barangay}');
        return null;
      },
    );

    final city = cities.firstWhere(
      (c) => c['city_code'].toString() == widget.city,
      orElse: () {
        print('No matching city found for code: ${widget.city}');
        return null;
      },
    );

    setState(() {
      barangayName = barangay?['brgy_name'];
      cityName = city?['city_name'];
    });
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
          MaterialPageRoute(builder: (context) => const QRPage()),
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

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
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
                        Navigator.pop(context);
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Details',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: profileImageUrl != null
                              ? Image.network(
                                  profileImageUrl!,
                                  fit: BoxFit.cover,
                                  height: 400,
                                )
                              : Container(
                                  height: 400,
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: Text(
                                      widget.establishmentName[0],
                                      style: const TextStyle(
                                        fontSize: 100,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, top: 315),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: 290,
                          height: 170,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.establishmentName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF288F13),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${barangayName ?? 'Loading...'}, ${cityName ?? 'Loading...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        index < averageRating.floor()
                                            ? Icons.star
                                            : (index < averageRating
                                                ? Icons.star_half
                                                : Icons.star_border),
                                        color: Colors.yellow,
                                        size: 20,
                                      );
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${averageRating.toStringAsFixed(1)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '($totalReviews reviews)',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          aboutText,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
