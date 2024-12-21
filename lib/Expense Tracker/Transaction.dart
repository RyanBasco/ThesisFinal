import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:testing/Groups/History.dart';
import 'package:testing/Groups/Travel.dart';
import 'package:testing/Expense%20Tracker/Categories.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  int _selectedIndex = 2;
  Map<String, double> spendingData = {};
  double totalSpending = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> orderedCategories = [
    'Accommodation',
    'Food and Beverages',
    'Transportation',
    'Attractions and Activities',
    'Shopping',
    'Entertainment',
    'Wellness and Spa Services',
    'Adventure and Outdoor Activities',
    'Travel Insurance',
    'Local Tours and Guides',
  ];

  @override
  void initState() {
    super.initState();
    _fetchSpendingData();
  }

  Future<void> _fetchSpendingData() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    String uid = currentUser.uid;
    DatabaseReference visitsRef = FirebaseDatabase.instance.ref('Visits');

    Map<String, double> categorySpending = {};

    try {
      DataSnapshot visitsSnapshot = await visitsRef.get();

      if (visitsSnapshot.exists) {
        visitsSnapshot.children.forEach((document) {
          final visitData = Map<String, dynamic>.from(document.value as Map);
          final userUID = visitData['User']?['UID'];
          final category = visitData['Category'] as String?;
          final totalSpend = double.tryParse(visitData['TotalSpend'].toString()) ?? 0.0;

          if (userUID == uid && category != null) {
            categorySpending[category] = (categorySpending[category] ?? 0.0) + totalSpend;
          }
        });
      }

      setState(() {
        spendingData = categorySpending;
        totalSpending = categorySpending.values.fold(0.0, (sum, amount) => sum + amount);
      });
    } catch (e) {
      print("Error fetching spending data: $e");
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

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
    );
  }

  Widget _buildLegendItem(String category) {
    double percentage = (spendingData[category] ?? 0) / totalSpending * 100;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getCategoryColor(category),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$category - ${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xFF51F643),
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 65,
        index: _selectedIndex,
        animationDuration: Duration(milliseconds: 600),
        animationCurve: Curves.easeInOut,
        items: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home, size: 24, color: _selectedIndex == 0 ? Color(0xFF27AE60) : Colors.grey),
              Text('Home', style: TextStyle(color: _selectedIndex == 0 ? Color(0xFF27AE60) : Colors.grey, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.travel_explore, size: 24, color: _selectedIndex == 1 ? Color(0xFF27AE60) : Colors.grey),
              Text('Travel', style: TextStyle(color: _selectedIndex == 1 ? Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.attach_money, size: 24, color: _selectedIndex == 2 ? Color(0xFF27AE60) : Colors.grey),
              Text('Transaction', style: TextStyle(color: _selectedIndex == 2 ? Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 24, color: _selectedIndex == 3 ? Color(0xFF27AE60) : Colors.grey),
              Text('History', style: TextStyle(color: _selectedIndex == 3 ? Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person, size: 24, color: _selectedIndex == 4 ? Color(0xFF27AE60) : Colors.grey),
              Text('Profile', style: TextStyle(color: _selectedIndex == 4 ? Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
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
            colors: [Color(0xFFEEFFA9), Color(0xFFDBFF4C), Color(0xFF51F643)],
            stops: [0.15, 0.54, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding:  EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                child: Row(
                  children: [
                    Padding(
                padding:  EdgeInsets.only(left: 75.0),
                child: Text(
                  'Expense Tracker',
                  style:  TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Expenses',
                              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CustomPaint(
                              painter: PieChartPainter(spendingData: spendingData, totalSpending: totalSpending),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: orderedCategories.map((category) => _buildLegendItem(category)).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesPage()));
                        },
                        icon: const Icon(Icons.remove_red_eye, color: Colors.white),
                        label: const Text(
                          'View Categories',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF288F13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35,)
            ],
          ),
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final Map<String, double> spendingData;
  final double totalSpending;

  PieChartPainter({required this.spendingData, required this.totalSpending});

  @override
  void paint(Canvas canvas, Size size) {
    if (totalSpending == 0) return;

    final rect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2);
    double startAngle = -3.14 / 2;

    spendingData.forEach((category, amount) {
      final sweepAngle = (amount / totalSpending) * 2 * 3.14;
      final paint = Paint()
        ..color = _getCategoryColor(category)
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Color _getCategoryColor(String category) {
  switch (category) {
    case 'Accommodation':
      return Colors.red;
    case 'Food and Beverages':
      return Colors.green;
    case 'Transportation':
      return Colors.blue;
    case 'Attractions and Activities':
      return Colors.orange;
    case 'Shopping':
      return Colors.cyan;
    case 'Entertainment':
      return Colors.purple;
    case 'Wellness and Spa Services':
      return Colors.brown;
    case 'Adventure and Outdoor Activities':
      return Colors.yellow;
    case 'Travel Insurance':
      return Colors.pink;
    case 'Local Tours and Guides':
      return Colors.indigo;
    default:
      return Colors.grey;
  }
}
