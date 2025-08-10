import 'package:flutter/material.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/Groups/History.dart';
import 'package:testing/Groups/Travel.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _selectedIndex = 2;
  String? _selectedCategory;
  List<Map<String, dynamic>> visits = [];

  // Define the list of categories with icons and colors
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Accommodation',
      'icon': Icons.hotel,
      'color': Colors.blueAccent,
    },
    {
      'name': 'Food and Beverages',
      'icon': Icons.restaurant,
      'color': Colors.redAccent,
    },
    {
      'name': 'Transportation',
      'icon': Icons.directions_car,
      'color': Colors.greenAccent,
    },
    {
      'name': 'Attractions and Activities',
      'icon': Icons.local_activity,
      'color': Colors.orangeAccent,
    },
    {
      'name': 'Shopping',
      'icon': Icons.shopping_cart,
      'color': Colors.purpleAccent,
    },
    {
      'name': 'Entertainment',
      'icon': Icons.theater_comedy,
      'color': Colors.pinkAccent,
    },
    {
      'name': 'Adventure and Outdoor Activities',
      'icon': Icons.terrain,
      'color': Colors.brown,
    },
    {
      'name': 'Travel Insurance',
      'icon': Icons.shield,
      'color': Colors.indigoAccent,
    },
    {
      'name': 'Local Tours and Guides',
      'icon': Icons.tour,
      'color': Colors.cyan,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchVisits();
  }

  Future<void> _fetchVisits() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference ref = FirebaseDatabase.instance.ref().child('Visits');
        DatabaseEvent event = await ref.once();

        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> visitsData =
              event.snapshot.value as Map<dynamic, dynamic>;

          List<Map<String, dynamic>> tempVisits = [];

          visitsData.forEach((key, value) {
            if (value is Map &&
                value['User'] is Map &&
                value['User']['UID'] == user.uid) {
              tempVisits.add({
                'category': value['Category'] ?? '',
                'date': value['Date'] ?? '',
                'time': value['Time'] ?? '',
                'totalSpend': value['TotalSpend'] ?? 0,
              });
            }
          });

          // Sort visits by date and time (latest first)
          tempVisits.sort((a, b) {
            // Parse MM/DD/YYYY format to DateTime objects
            List<String> partsA = a['date'].toString().split('/');
            List<String> partsB = b['date'].toString().split('/');

            DateTime dateA = DateTime(
                int.parse(partsA[2]), // year
                int.parse(partsA[0]), // month
                int.parse(partsA[1]) // day
                );
            DateTime dateB = DateTime(
                int.parse(partsB[2]), // year
                int.parse(partsB[0]), // month
                int.parse(partsB[1]) // day
                );

            int dateComparison = dateB.compareTo(dateA);
            if (dateComparison != 0) return dateComparison;

            // If dates are equal, compare times
            return b['time'].toString().compareTo(a['time'].toString());
          });

          setState(() {
            visits = tempVisits;
          });
        }
      }
    } catch (e) {
      print('Error fetching visits: $e');
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

  void navigateToCategoryPage(String categoryName) {
    setState(() {
      _selectedCategory = categoryName;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter visits based on the selected category
    List<Map<String, dynamic>> filteredVisits = _selectedCategory == null
        ? visits
        : visits
            .where((visit) => visit['category'] == _selectedCategory)
            .toList();

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
              Icon(Icons.home,
                  size: 24,
                  color: _selectedIndex == 0
                      ? const Color(0xFF27AE60)
                      : Colors.grey),
              Text('Home',
                  style: TextStyle(
                      color: _selectedIndex == 0
                          ? const Color(0xFF27AE60)
                          : Colors.grey,
                      fontSize: 10),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.travel_explore,
                  size: 24,
                  color: _selectedIndex == 1
                      ? const Color(0xFF27AE60)
                      : Colors.grey),
              Text('Travel',
                  style: TextStyle(
                      color: _selectedIndex == 1
                          ? const Color(0xFF27AE60)
                          : Colors.grey,
                      fontSize: 10),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.attach_money,
                  size: 24,
                  color: _selectedIndex == 2
                      ? const Color(0xFF27AE60)
                      : Colors.grey),
              Text('Transaction',
                  style: TextStyle(
                      color: _selectedIndex == 2
                          ? const Color(0xFF27AE60)
                          : Colors.grey,
                      fontSize: 10),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history,
                  size: 24,
                  color: _selectedIndex == 3
                      ? const Color(0xFF27AE60)
                      : Colors.grey),
              Text('History',
                  style: TextStyle(
                      color: _selectedIndex == 3
                          ? const Color(0xFF27AE60)
                          : Colors.grey,
                      fontSize: 10),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person,
                  size: 24,
                  color: _selectedIndex == 4
                      ? const Color(0xFF27AE60)
                      : Colors.grey),
              Text('Profile',
                  style: TextStyle(
                      color: _selectedIndex == 4
                          ? const Color(0xFF27AE60)
                          : Colors.grey,
                      fontSize: 10),
                  overflow: TextOverflow.ellipsis),
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
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(
                            context); // Navigate back to the previous page
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Categories',
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
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ALL CATEGORIES',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF585858),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  children: [
                    DropdownButton<String>(
                      value: _selectedCategory,
                      hint: Text('Select a category'),
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category['name'],
                          child: Text(category['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        navigateToCategoryPage(value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    ...filteredVisits.map((visit) {
                      return ListTile(
                        title: Text(visit['category']),
                        subtitle: Text('${visit['date']} at ${visit['time']}'),
                        trailing: Text(
                          '₱${visit['totalSpend']}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    if (filteredVisits.isEmpty)
                      const Text(
                        'No visits found for this category.',
                        style: TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
