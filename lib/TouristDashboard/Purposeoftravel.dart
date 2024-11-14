import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Purposeoftravel extends StatefulWidget {
  @override
  _PurposeoftravelState createState() => _PurposeoftravelState();
}

class _PurposeoftravelState extends State<Purposeoftravel> {
  int _selectedIndex = 1;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  TextEditingController _otherPurposeController = TextEditingController();
  bool _isEditing = false;
  String? _purposeOfTravel;
  bool _isOtherSelected = false;

  @override
  void initState() {
    super.initState();
    _fetchPurposeOfTravel();
  }

  Future<void> _fetchPurposeOfTravel() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DatabaseReference userRef = _dbRef.child('Users').child(userId);

      DatabaseEvent event = await userRef.once();
      if (event.snapshot.exists) {
        Map<String, dynamic> userData = Map<String, dynamic>.from(event.snapshot.value as Map);

        if (mounted) {
          setState(() {
            _purposeOfTravel = userData['purpose_of_travel'] ?? 'Not specified';
            _otherPurposeController.text = userData['otherPurpose'] ?? '';
            _isOtherSelected = _purposeOfTravel == 'Other';
          });
        }
      }
    }
  }

  Future<void> _savePurposeOfTravel() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DatabaseReference userRef = _dbRef.child('Users').child(userId);

      if (_isOtherSelected) {
        await userRef.update({
          'purpose_of_travel': _purposeOfTravel,
          'otherPurpose': _otherPurposeController.text,
        });
      } else {
        await userRef.update({
          'purpose_of_travel': _purposeOfTravel,
        });
        userRef.child('otherPurpose').remove();
      }

      if (mounted) {
        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purpose of travel updated successfully!')),
        );
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _fetchPurposeOfTravel();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserdashboardPageState()),
        );
        break;
      case 1:
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
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color(0xFF2C812A),
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
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
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
                          child: Padding(
                            padding: EdgeInsets.only(right: 45.0, top: 10.0),
                            child: Text(
                              'Purpose of Travel',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Purpose of Travel',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (_isEditing)
                            Column(
                              children: [
                                DropdownButtonFormField<String>(
                                  value: _purposeOfTravel,
                                  items: ['Business', 'Leisure', 'MICE', 'Other'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _purposeOfTravel = newValue;
                                      _isOtherSelected = newValue == 'Other';
                                      if (!_isOtherSelected) {
                                        _otherPurposeController.clear();
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Select Purpose of Travel',
                                  ),
                                ),
                                if (_isOtherSelected)
                                  const SizedBox(height: 10),
                                if (_isOtherSelected)
                                  TextFormField(
                                    controller: _otherPurposeController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter other purpose',
                                      labelText: 'Other Purpose',
                                    ),
                                  ),
                              ],
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _purposeOfTravel ?? 'Not specified',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_isEditing)
                                ElevatedButton(
                                  onPressed: _cancelEdit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              if (_isEditing)
                                ElevatedButton(
                                  onPressed: _savePurposeOfTravel,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2C812A),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              if (!_isEditing)
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2C812A),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
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
}
