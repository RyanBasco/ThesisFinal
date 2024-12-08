import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/Groups/QrPage.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int _selectedIndex = 0;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  bool _isDialogVisible = false;
  List<Map<String, dynamic>> _pendingReviews = [];
  Map<String, double> _categoryRatings = {};
  bool _showRatingScreen = false;
  String? _currentReviewKey;
  double _rating = 0.0;
  String _comment = '';

  @override
  void initState() {
    super.initState();
    _checkForPendingReviews();
  }

  void _checkForPendingReviews() {
    _databaseRef.child('PendingReviews').onChildAdded.listen((event) {
      final pendingReview = event.snapshot.value as Map<dynamic, dynamic>;
      if (pendingReview['status'] == 'pending') {
        setState(() {
          _pendingReviews.add({
            'reviewKey': event.snapshot.key,
            'establishmentId': pendingReview['establishment_id'],
            'categories': pendingReview['categories']
          });
        });
      }
    });

    _databaseRef.child('PendingReviews').onChildRemoved.listen((event) {
      setState(() {
        _pendingReviews.removeWhere((review) => review['reviewKey'] == event.snapshot.key);
      });
    });
  }

  void _showReviewDialog(String reviewKey, List<dynamic> categories) {
    setState(() {
      _showRatingScreen = true;
      _currentReviewKey = reviewKey;
      _categoryRatings = Map.fromEntries(
        categories.map((category) => MapEntry(category['category'].toString(), 0.0))
      );
    });
  }

  void _submitReview(String reviewKey, double rating, String comment) async {
    try {
      final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('No user logged in');
      }

      final pendingReviewSnapshot = await _databaseRef.child('PendingReviews/$reviewKey').get();
      String? establishmentId = pendingReviewSnapshot.value != null
          ? (pendingReviewSnapshot.value as Map)['establishment_id']
          : null;

      if (establishmentId != null) {
        final userSnapshot = await _databaseRef.child('Users/$currentUserId').get();
        if (userSnapshot.exists) {
          final userData = Map<String, dynamic>.from(userSnapshot.value as Map);
          String firstName = userData['first_name'] ?? 'User';
          String lastName = userData['last_name'] ?? '';

          await _databaseRef.child('reviews').push().set({
            'categoryRatings': _categoryRatings,
            'comment': _comment,
            'first_name': firstName,
            'last_name': lastName,
            'establishment_id': establishmentId,
            'timestamp': ServerValue.timestamp,
            'user_id': currentUserId,
          });

          await _databaseRef.child('PendingReviews/$reviewKey').update({'status': 'completed'});

          setState(() {
            _pendingReviews.removeWhere((review) => review['reviewKey'] == reviewKey);
            _showRatingScreen = false;
            _currentReviewKey = null;
          });
        }
      }
    } catch (e) {
      print('Error submitting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review. Please try again.')),
      );
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
    if (_showRatingScreen) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showRatingScreen = false;
                              _currentReviewKey = null;
                              _rating = 0.0;
                              _comment = '';
                            });
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.arrow_back, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Give Feedback',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    const Text(
                      'Rate each category:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    ..._categoryRatings.entries.map((entry) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RatingBar.builder(
                          initialRating: entry.value,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 30,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _categoryRatings[entry.key] = rating;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    )).toList(),

                    const Text(
                      'Overall Comments:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (text) {
                        setState(() {
                          _comment = text;
                        });
                      },
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your comments here...',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF288F13),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          _submitReview(_currentReviewKey!, _rating, _comment);
                          setState(() {
                            _showRatingScreen = false;
                            _currentReviewKey = null;
                          });
                        },
                        child: const Text('Submit Review'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                      const SizedBox(width: 110),
                      const Text(
                        'Support',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_pendingReviews.isNotEmpty)
                  ..._pendingReviews.map((review) {
                    return GestureDetector(
                      onTap: () => _showReviewDialog(
                        review['reviewKey'] as String,
                        (review['categories'] ?? []) as List<dynamic>
                      ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rate Your Experience',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Share your feedback about your recent visit',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList()
                else
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No Pending Reviews',
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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
      ),
    );
  }
}
