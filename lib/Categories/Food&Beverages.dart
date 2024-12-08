import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:testing/Receipt/FoodReceipt.dart';
import 'package:testing/Groups/QrPage.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class Foodandbeverages extends StatefulWidget {
  @override
  _FoodandbeveragesState createState() => _FoodandbeveragesState();
}

class _FoodandbeveragesState extends State<Foodandbeverages> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> foodAndBeverageVisits = [];
  bool isLoading = true;
  int _selectedIndex = 2;

  Map<String, String> barangayMap = {};
  Map<String, String> cityMap = {};

  @override
  void initState() {
    super.initState();
    loadLocationNames();
    fetchFoodAndBeverageVisits();
  }

  Future<void> loadLocationNames() async {
    // Load barangay and city JSON data
    final String barangayData = await rootBundle.loadString('assets/barangay.json');
    final String cityData = await rootBundle.loadString('assets/city.json');

    final List<dynamic> barangays = json.decode(barangayData);
    final List<dynamic> cities = json.decode(cityData);

    setState(() {
      barangayMap = {for (var b in barangays) b['brgy_code']: b['brgy_name']};
      cityMap = {for (var c in cities) c['city_code']: c['city_name']};
    });
  }

  Future<void> fetchFoodAndBeverageVisits() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    String uid = currentUser.uid;
    DatabaseReference visitsRef = FirebaseDatabase.instance.ref('Visits');

    try {
      DataSnapshot visitsSnapshot = await visitsRef.get();

      if (visitsSnapshot.exists) {
        visitsSnapshot.children.forEach((document) {
          final visitData = (document.value as Map<Object?, Object?>).map(
            (key, value) => MapEntry(key.toString(), value),
          );
          
          final userData = visitData['User'] as Map?;
          final visitUid = userData?['UID'];
          
          if (visitUid == uid && visitData['Category'] == 'Food and Beverages') {
            final establishment = visitData['Establishment'] as Map?;
            String barangayCode = establishment?['barangay']?.toString() ?? 'Unknown';
            String cityCode = establishment?['city']?.toString() ?? 'Unknown';
            String barangay = barangayMap[barangayCode] ?? 'Unknown';
            String city = cityMap[cityCode] ?? 'Unknown';

            setState(() {
              foodAndBeverageVisits.add({
                'establishmentName': establishment?['establishmentName']?.toString() ?? 'N/A',
                'address': '$city, $barangay',
                'date': visitData['Date']?.toString() ?? 'N/A',
                'totalSpend': double.tryParse(visitData['TotalSpend']?.toString() ?? '0.0') ?? 0.0,
              });
            });
          }
        });
      }

      if (foodAndBeverageVisits.isEmpty) {
        setState(() {
          foodAndBeverageVisits.add({
            'establishmentName': 'Currently no expense in this Food and Beverages category.',
            'address': '',
            'date': '',
            'totalSpend': '',
          });
        });
      }
    } catch (e) {
      print("Error fetching food and beverage visits: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
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
        break; // Current page
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TouristprofilePage()),
        );
        break;
    }
  }

  void _navigateToDetail(Map<String, dynamic> visit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodReceiptDetailPage(
          establishmentName: visit['establishmentName'],
          address: visit['address'],
          date: visit['date'],
          totalSpend: visit['totalSpend'] ?? 0.0, // Pass totalSpend
        ),
      ),
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
            colors: [Color(0xFFEEFFA9), Color(0xFFDBFF4C), Color(0xFF51F643)],
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
                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        'Food and Beverages',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Food and Beverages History',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: foodAndBeverageVisits.length,
                        itemBuilder: (context, index) {
                          final visit = foodAndBeverageVisits[index];
                          return GestureDetector(
                            onTap: () => _navigateToDetail(visit),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (visit['address'] != '')
                                  ...[
                                    Text(
                                      'Establishment Name: ${visit['establishmentName']}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text('Address: ${visit['address']}'),
                                    Text('Date: ${visit['date']}'),
                                    Divider(color: Colors.grey[400]),
                                  ]
                                else
                                  Text(
                                    visit['establishmentName'],
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            ),
                          );
                        },
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
