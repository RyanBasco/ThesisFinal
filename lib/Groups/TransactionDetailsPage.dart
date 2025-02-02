import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/Groups/Travel.dart';
import 'package:testing/Groups/History.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:firebase_database/firebase_database.dart';

class TransactionDetailsPage extends StatefulWidget {
  final Map<String, dynamic> transactionData;

  const TransactionDetailsPage({
    Key? key,
    required this.transactionData,
  }) : super(key: key);

  @override
  _TransactionDetailsPageState createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  int _selectedIndex = 3;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<DataSnapshot>(
                  future: FirebaseDatabase.instance
                      .ref()
                      .child('Visits')
                      .orderByChild('Date')
                      .equalTo(widget.transactionData['date'])
                      .once()
                      .then((event) => event.snapshot),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error loading details'));
                    }

                    if (snapshot.hasData && snapshot.data!.value != null) {
                      Map<dynamic, dynamic> visitsData =
                          snapshot.data!.value as Map<dynamic, dynamic>;
                      var visitData = visitsData.values.first;
                      String establishmentName =
                          visitData['Establishment']['establishmentName'] ??
                              'Unknown Establishment';

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipPath(
                          clipper: ReceiptClipper(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(
                                          _getCategoryIcon(
                                              widget.transactionData['category']),
                                          color: Color(0xFF27AE60),
                                          size: 40,
                                        ),
                                        title: Text(
                                          establishmentName,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          widget.transactionData['category'] ??
                                              'Unknown Category',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Divider(),
                                      _buildDetailRow(
                                          'Date',
                                          widget.transactionData['date'] ??
                                              'Not specified'),
                                      _buildDetailRow(
                                          'Time',
                                          _formatTime(
                                              widget.transactionData['time'])),
                                      _buildDetailRow(
                                          'Amount',
                                          '₱${widget.transactionData['totalSpend']}'),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return Center(child: Text('No details found'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFF51F643),
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 65,
        index: _selectedIndex,
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
                      fontSize: 10)),
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
                      fontSize: 10)),
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
                      fontSize: 10)),
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
                      fontSize: 10)),
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
                      fontSize: 10)),
            ],
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'accommodation':
        return Icons.hotel;
      case 'food':
        return Icons.restaurant;
      case 'transportation':
        return Icons.directions_car;
      case 'entertainment':
        return Icons.movie;
      default:
        return Icons.receipt;
    }
  }

  String _formatTime(String? time) {
    if (time == null) return '';
    try {
      List<String> parts = time.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      String period = hours >= 12 ? 'PM' : 'AM';
      hours = hours > 12 ? hours - 12 : hours;
      hours = hours == 0 ? 12 : hours;
      return '$hours:${minutes.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time;
    }
  }
}

class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 20);

    double x = 0;
    double y = size.height - 20;
    double increment = size.width / 20;

    while (x < size.width) {
      x += increment;
      y = y == size.height - 20 ? size.height : size.height - 20;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}