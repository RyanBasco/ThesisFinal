import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int _selectedIndex = 0;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  bool _hasPendingReviewNotification = false; // Flag for pending review notification
  String? _pendingReviewKey; // Stores the review key if a review is pending

  @override
  void initState() {
    super.initState();
    _checkForPendingReviews();
  }

  void _checkForPendingReviews() {
    _databaseRef.child('pendingReviews').onChildAdded.listen((event) {
      final pendingReview = event.snapshot.value as Map<dynamic, dynamic>;
      if (pendingReview['status'] == 'pending') {
        _pendingReviewKey = event.snapshot.key!;
        setState(() {
          _hasPendingReviewNotification = true;
        });
        _showReviewDialog(_pendingReviewKey!);
      }
    });
  }

  void _showReviewDialog(String reviewKey) {
    double rating = 0.0;
    String comment = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 16, left: 16, right: 8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Give Feedback',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _hasPendingReviewNotification = true;
                  });
                },
                child: const Icon(Icons.close, color: Colors.grey),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please provide your rating:'),
              const SizedBox(height: 16),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                },
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add Comments, if any:',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  onChanged: (text) {
                    comment = text;
                  },
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your comments here...',
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF288F13),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  _submitReview(reviewKey, rating, comment);
                  Navigator.of(context).pop();
                  setState(() {
                    _hasPendingReviewNotification = false;
                  });
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _submitReview(String reviewKey, double rating, String comment) async {
    try {
      final pendingReviewSnapshot = await _databaseRef.child('pendingReviews/$reviewKey').get();
      String? establishmentId = pendingReviewSnapshot.value != null 
          ? (pendingReviewSnapshot.value as Map)['establishment_id'] 
          : null;

      if (establishmentId != null) {
        final userSnapshot = await _databaseRef.child('Users/$reviewKey').get();
        if (userSnapshot.exists) {
          final userData = Map<String, dynamic>.from(userSnapshot.value as Map);
          String firstName = userData['first_name'] ?? 'User';
          String lastName = userData['last_name'] ?? '';

          await _databaseRef.child('reviews').push().set({
            'rating': rating,
            'comment': comment,
            'first_name': firstName,
            'last_name': lastName,
            'establishment_id': establishmentId,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          });

          await _databaseRef.child('pendingReviews/$reviewKey').update({'status': 'completed'});
        }
      }
    } catch (e) {
      print('Error submitting review: $e');
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 80),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            if (_hasPendingReviewNotification)
              GestureDetector(
                onTap: () => _showReviewDialog(_pendingReviewKey!),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications, color: Colors.amber),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'You have a pending review to complete',
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // Ensures the text stays on a single line
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Text(
                    'No Notifications Available',
                    style: TextStyle(
                      fontSize: 21, // Increase font size for emphasis
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF2C812A),
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'My QR'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
