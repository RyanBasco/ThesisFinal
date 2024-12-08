import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:testing/Receipt/Transportationreceipt.dart';
import 'package:testing/Groups/QrPage.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class Transportation extends StatefulWidget {
  @override
  _TransportationState createState() => _TransportationState();
}

class _TransportationState extends State<Transportation> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> transportationVisits = [];
  bool isLoading = true;
  int _selectedIndex = 2;

  Map<String, String> barangayMap = {};
  Map<String, String> cityMap = {};

  @override
  void initState() {
    super.initState();
    loadLocationNames();
    fetchTransportationVisits();
  }

  Future<void> loadLocationNames() async {
    final String barangayData = await rootBundle.loadString('assets/barangay.json');
    final String cityData = await rootBundle.loadString('assets/city.json');

    final List<dynamic> barangays = json.decode(barangayData);
    final List<dynamic> cities = json.decode(cityData);

    setState(() {
      barangayMap = {for (var b in barangays) b['brgy_code']: b['brgy_name']};
      cityMap = {for (var c in cities) c['city_code']: c['city_name']};
    });
  }

  Future<void> fetchTransportationVisits() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    String uid = currentUser.uid;
    DatabaseReference visitsRef = FirebaseDatabase.instance.ref('Visits');

    try {
      DataSnapshot visitsSnapshot = await visitsRef.get();

      if (visitsSnapshot.exists) {
        setState(() {
          transportationVisits.clear(); // Clear existing visits first
        });

        visitsSnapshot.children.forEach((document) {
          final visitData = document.value as Map?;
          if (visitData != null && 
              visitData['User'] is Map && 
              visitData['User']['UID'] == uid && 
              visitData['Category'] == 'Transportation') {
            
            final establishment = visitData['Establishment'] as Map?;
            if (establishment != null) {
              String barangayCode = establishment['barangay']?.toString() ?? 'Unknown';
              String cityCode = establishment['city']?.toString() ?? 'Unknown';
              String barangay = barangayMap[barangayCode] ?? 'Unknown';
              String city = cityMap[cityCode] ?? 'Unknown';

              setState(() {
                transportationVisits.add({
                  'establishmentName': establishment['establishmentName'] ?? 'N/A',
                  'address': '$city, $barangay',
                  'date': visitData['Date'] ?? 'N/A',
                  'totalSpend': visitData['TotalSpend']?.toDouble() ?? 0.0,
                });
              });
            }
          }
        });

        if (transportationVisits.isEmpty) {
          setState(() {
            transportationVisits.add({
              'establishmentName': 'Currently no expense in this Transportation category.',
              'address': '',
              'date': '',
              'totalSpend': 0.0,
            });
          });
        }
      }
    } catch (e) {
      print("Error fetching transportation visits: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToDetail(Map<String, dynamic> visit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransportationReceiptDetailPage(
          establishmentName: visit['establishmentName'],
          address: visit['address'],
          date: visit['date'],
          totalSpend: visit['totalSpend'] ?? 0.0, // Pass totalSpend for details page
        ),
      ),
    );
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'My QR'),
            BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Expense Tracker'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
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
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 42),
                      child: Text(
                        'Transportation',
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
                    Text(
                      'Transportation History',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    if (isLoading)
                      CircularProgressIndicator()
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: transportationVisits.length,
                        itemBuilder: (context, index) {
                          final visit = transportationVisits[index];
                          return GestureDetector(
                            onTap: () => _navigateToDetail(visit),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (visit['address'] != '')
                                  ...[
                                    Text(
                                      'Establishment Name: ${visit['establishmentName']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text('Address: ${visit['address']}'),
                                    Text('Date: ${visit['date']}'),
                                    Divider(color: Colors.grey[400]),
                                  ]
                                else
                                  Text(
                                    visit['establishmentName'],
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
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
