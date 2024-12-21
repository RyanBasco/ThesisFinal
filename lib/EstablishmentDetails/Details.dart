import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:testing/Groups/History.dart';
import 'package:testing/Groups/Travel.dart';
import 'package:testing/Expense%20Tracker/Transaction.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
  String contactInfo = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadLocationNames();
    _fetchEstablishmentImage();
    _fetchAboutText();
    _fetchAverageRating();
    _fetchContactInfo();
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

  Future<void> _fetchContactInfo() async {
    try {
      DatabaseReference dbRef =
          FirebaseDatabase.instance.ref('establishments/${widget.establishmentId}');
      final snapshot = await dbRef.child('contact').get();

      if (snapshot.exists) {
        setState(() {
          contactInfo = snapshot.value as String;
        });
      } else {
        print('No contact information found for this establishment.');
      }
    } catch (e) {
      print('Error fetching contact information: $e');
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

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        onTap: _onItemTapped,
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
                      padding: const EdgeInsets.only(left: 7, top: 385),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
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
                                      double difference = averageRating - index;
                                      if (difference >= 1) {
                                        return const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 20,
                                        );
                                      } else if (difference > 0) {
                                        return Stack(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                            ClipRect(
                                              clipper: _StarClipper(difference),
                                              child: const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                 size: 20,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const Icon(
                                          Icons.star,
                                          color: Colors.grey,
                                          size: 20,
                                        );
                                      }
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 250),
                child: const Text(
                  'Contact',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 115),
                child: Container(
                  width: 200,
                  height: 60,
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
                    child: Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          contactInfo,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double percentage;

  _StarClipper(this.percentage);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * percentage, size.height);
  }

  @override
  bool shouldReclip(_StarClipper oldClipper) {
    return percentage != oldClipper.percentage;
  }
}
