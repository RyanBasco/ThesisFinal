import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/Groups/History.dart';
import 'package:testing/Groups/Travel.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int _selectedIndex = 4;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  bool _isDialogVisible = false;
  List<Map<String, dynamic>> _pendingReviews = [];
  Map<String, double> _categoryRatings = {};
  bool _showRatingScreen = false;
  String? _currentReviewKey;
  double _rating = 0.0;
  String _comment = '';
  Map<String, String> _categoryComments = {};
  String _establishmentName = '';

  @override
  void initState() {
    super.initState();
    _checkForPendingReviews();
  }

 void _checkForPendingReviews() {
  final String? currentUserId = FirebaseAuth.instance.currentUser ?.uid;
  if (currentUserId == null) return;

  _databaseRef.child('PendingReviews').onChildAdded.listen((event) {
    final pendingReview = event.snapshot.value as Map<dynamic, dynamic>;
    // Only add review if it's pending and belongs to current user
    if (pendingReview['status'] == 'pending' && 
        pendingReview['user_id'] == currentUserId) {
      setState(() {
        // Insert the new review at the beginning of the list
        _pendingReviews.insert(0, {
          'reviewKey': event.snapshot.key,
          'establishmentId': pendingReview['establishment_id'],
          'categories': pendingReview['categories']
        });
      });
    }
  });

  _databaseRef.child('PendingReviews').onChildRemoved.listen((event) {
    final removedReview = event.snapshot.value as Map<dynamic, dynamic>;
    // Only remove if it belongs to current user
    if (removedReview['user_id'] == currentUserId) {
      setState(() {
        _pendingReviews.removeWhere((review) => review['reviewKey'] == event.snapshot.key);
      });
    }
  });
}

  void _showReviewDialog(String reviewKey, List<dynamic> categories) async {
    setState(() {
      _showRatingScreen = true;
      _currentReviewKey = reviewKey;
      _categoryRatings = Map.fromEntries(
        categories.map((category) => MapEntry(category['category'].toString(), 0.0))
      );
    });

    final pendingReviewSnapshot = await _databaseRef.child('PendingReviews/$reviewKey').get();
    String? establishmentId = pendingReviewSnapshot.value != null
        ? (pendingReviewSnapshot.value as Map)['establishment_id']
        : null;

    if (establishmentId != null) {
        final establishmentSnapshot = await _databaseRef.child('establishments/$establishmentId').get();
        _establishmentName = establishmentSnapshot.value != null
            ? (establishmentSnapshot.value as Map)['establishmentName'] ?? 'Unknown Establishment'
            : '';
    } else {
        _establishmentName = 'Unknown Establishment';
    }
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

        // Get current date and time with proper formatting
        final now = DateTime.now();
        final formattedDate = "${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}";
        final formattedTime = "${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";

        await _databaseRef.child('reviews').push().set({
          'categoryRatings': _categoryRatings,
          'categoryComments': _categoryComments,
          'first_name': firstName,
          'last_name': lastName,
          'establishment_id': establishmentId,
          'date': formattedDate,
          'timestamp': formattedTime,
          'user_id': currentUserId,
        });

       
        await _databaseRef.child('PendingReviews/$reviewKey').update({'status': 'completed'});

       
        setState(() {
          _pendingReviews.removeWhere((review) => review['reviewKey'] == reviewKey);
          _showRatingScreen = false;
          _currentReviewKey = null;
          _categoryRatings.clear();
          _categoryComments.clear();
        });

  
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submitted successfully!')),
        );
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

  @override
  Widget build(BuildContext context) {
    if (_showRatingScreen) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Container(
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
            child: SingleChildScrollView(
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
                        const SizedBox(width: 50),
                        const Text(
                          'Give Feedback',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    Text(
                      _establishmentName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
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
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (text) {
                            setState(() {
                              _categoryComments[entry.key] = text;
                            });
                          },
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your comments for ${entry.key}...',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    )).toList(),

                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
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
                    const SizedBox(height: 32),
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
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
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
              child: Padding(
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
                    const SizedBox(width: 45),
                    const Text(
                      'Pending Reviews',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
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
                      if (_pendingReviews.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _pendingReviews.length,
                          itemBuilder: (context, index) {
                            final review = _pendingReviews[index];
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
                          },
                        )
                      else
                        const Center(
                          child: Text(
                            'No Pending Reviews',
                            style: TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: const Color(0xFF51F643),
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
                Text('Travel', style: TextStyle(color: _selectedIndex == 1 ? Color(0xFF27AE60) : Colors.grey, fontSize: 10)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.attach_money, size: 24, color: _selectedIndex == 2 ? Color(0xFF27AE60) : Colors.grey),
                Text('Transaction', style: TextStyle(color: _selectedIndex == 2 ? Color(0xFF27AE60) : Colors.grey, fontSize: 10)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, size: 24, color: _selectedIndex == 3 ? Color(0xFF27AE60) : Colors.grey),
                Text('History', style: TextStyle(color: _selectedIndex == 3 ? Color(0xFF27AE60) : Colors.grey, fontSize: 10)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, size: 24, color: _selectedIndex == 4 ? Color(0xFF27AE60) : Colors.grey),
                Text('Profile', style: TextStyle(color: _selectedIndex == 4 ? Color(0xFF27AE60) : Colors.grey, fontSize: 10)),
              ],
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
