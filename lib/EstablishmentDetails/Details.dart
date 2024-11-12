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
  final String establishmentId; // Add this line

  const DetailsPage({
    super.key,
    required this.establishmentName,
    required this.barangay,
    required this.city,
    required this.establishmentId, // Add this parameter here
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

  @override
  void initState() {
    super.initState();
    _loadLocationNames();
    _fetchEstablishmentImage();
  }

  Future<void> _fetchEstablishmentImage() async {
    try {
      // Use the provided establishmentId to fetch the profile image
      String filePath = 'Establishment/${widget.establishmentId}/profile_image/latest_image.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
      String downloadUrl = await storageRef.getDownloadURL();
      setState(() {
        profileImageUrl = downloadUrl;
      });
    } catch (e) {
      print('Error fetching profile image: $e');
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

  void _navigateToDirectionsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TouristServiceApp()),
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
                          height: 155,
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
                              const Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow, size: 20),
                                  Icon(Icons.star, color: Colors.yellow, size: 20),
                                  Icon(Icons.star, color: Colors.yellow, size: 20),
                                  Icon(Icons.star, color: Colors.yellow, size: 20),
                                  Icon(Icons.star_border, color: Colors.yellow, size: 20),
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: _contactButton('Contact', Icons.phone),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 80),
                      child: _contactButton('Facebook', Icons.facebook),
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
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Detailed description about the place goes here...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _navigateToDirectionsPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2C812A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        icon: const Icon(Icons.directions, color: Colors.white),
                        label: const Text(
                          'Directions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactButton(String label, IconData icon) {
    return Container(
      width: 120,
      height: 40,
      padding: const EdgeInsets.all(10),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: 20),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
