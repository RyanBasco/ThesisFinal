import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:testing/ItineraryPage/Itinerary.dart';
import 'package:testing/TouristDashboard/Registration.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'global.dart';
class ItineraryFormsPage extends StatefulWidget {
  @override
  _ItineraryFormsPageState createState() => _ItineraryFormsPageState();
}

class _ItineraryFormsPageState extends State<ItineraryFormsPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

   int _selectedIndex = 0;

   void _onItemTapped(int index) {
  if (index == 0) { // Check if "Home" option is tapped
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserdashboardPageState()), // Navigate to UserDashboard
    );
  } else if (index == 2) { // Check if "Registration" option is tapped
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()), // Navigate to RegisterAsIndividualPage
    );
  } else if (index == 3) { // Check if "Itinerary" option is tapped
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItineraryPage()), // Navigate to ItineraryPage
    );
  } else {
    setState(() {
      _selectedIndex = index;
    });
  }
}

  void _submitDataToFirebase() {
    // Retrieve values from the text fields
    String date = _dateController.text;
    String type = _typeController.text;
    String name = _nameController.text;
    String location = _locationController.text;
    String address = _addressController.text;

    // Generate a new unique key for the itinerary
    String itineraryId = _database.child('Itinerary').push().key ?? '';

    // Store the data using the generated key
    _database.child('ItineraryID').child(itineraryId).set({
      'Date': date,
      'Type of Establishment': type,
      'Name of Establishment': name,
      'Location': location,
      'Establishment': address,
    }).then((_) {
      // Add to local itinerary list
      itineraryList.add({
        'Date': date,
        'Type': type,
        'Name': name,
        'Location': location,
        'Address': address,
      });

      // Display success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Data successfully registered'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }).catchError((error) {
      print('Failed to submit data: $error');
      // Display error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to register data'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: Color(0xFFDEE77A),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Image.asset(
                            'assets/guimarasvist.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Builder(
                          builder: (context) => IconButton(
                            icon: Icon(Icons.menu, color: Colors.black),
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            Container(
              color: Color(0xFFDEE77A),
              padding: EdgeInsets.only(top: 40.0, bottom: 23, left: 27.0, right: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0), // Adjust this value to move the circle avatar
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: AssetImage('lib/assets/Vector.png'), // Replace with your image asset
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Juan Dela Cruz',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // You can add more items to the drawer here
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xFFDEE77A),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFFDEE77A),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color(0xFF2C812A),
          unselectedItemColor: Color(0xFF2C812A),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feed),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.app_registration),
              label: 'Registration',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Itinerary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Itinerary',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: '*Date',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Activity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _typeController,
                decoration: InputDecoration(
                  labelText: '*Type of Establishment',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '*Name of Establishment',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: '*Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: '*Establishment Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Additional Notes',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press
                    _submitDataToFirebase();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2C812A), // Button color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
