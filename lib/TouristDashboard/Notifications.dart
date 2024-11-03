import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int _selectedIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _currentUserEmail;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserEmail();
  }

  void _fetchCurrentUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserEmail = user.email!;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Handle "Home"
        break;
      case 1:
        // Handle "My QR"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRPage()),
        );
        break;
      case 2:
        // Handle "Wallet"
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
      bottomNavigationBar: BottomNavigationBar(
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
            label: 'My Qr',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Navigate back to the previous page
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Notifications',
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
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('FriendRequests').where('recipientEmail', isEqualTo: _currentUserEmail).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  List<DocumentSnapshot> requests = snapshot.data?.docs ?? [];
                  if (requests.isEmpty) {
                    return const Center(child: Text('No friend requests.'));
                  }

                  return Column(
                    children: requests.map((request) {
                      String senderEmail = request['senderEmail'];
                      String senderFirstName = request['senderFirstName'];
                      String senderLastName = request['senderLastName'];
                      String status = request['status'];
                      String requestId = request.id;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                status == 'accepted'
                                    ? 'You accepted $senderFirstName $senderLastName\'s friend request'
                                    : '$senderFirstName $senderLastName sent you a friend request',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              if (status != 'accepted') ...[
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _acceptFriendRequest(requestId);
                                      },
                                      child: const Text('Accept'),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        _deleteFriendRequest(requestId);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ]
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _acceptFriendRequest(String requestId) async {
  try {
    // Update status of the friend request in Firestore
    await _firestore.collection('FriendRequests').doc(requestId).update({
      'status': 'accepted',
    });

    // Refresh the UI or handle any necessary state changes
    if (mounted) {
      setState(() {});
    }
  } catch (e) {
    // Handle the error
    if (mounted) {
      setState(() {});
    }
  }
}

void _deleteFriendRequest(String requestId) async {
  try {
    // Delete the friend request document from Firestore
    await _firestore.collection('FriendRequests').doc(requestId).delete();

    // Refresh the UI
    if (mounted) {
      setState(() {});
    }
  } catch (e) {
    // Handle the error
    if (mounted) {
      setState(() {});
    }
  }
}
}
