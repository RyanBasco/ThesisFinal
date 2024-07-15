import 'package:flutter/material.dart';
import 'package:testing/ItineraryPage/ItineraryQr.dart';
import 'package:testing/ItineraryPage/Itineraryform.dart';
import 'package:testing/TouristDashboard/Registration.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';
import 'global.dart';

class ItineraryPage extends StatefulWidget {
  @override
  _ItineraryPageState createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
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


  void _addItinerary() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItineraryFormsPage()), // Navigate to ItineraryFormPage
    );
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50), // Creates border
                      color: Color(0xFF2C812A),
                    ),
                    tabs: [
                     Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Creates circular border
                    border: Border.all(color: Color(0xFF2C812A)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Itinerary List',
                      style: TextStyle(color: Colors.black), // Set text color to white
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Creates circular border
                    border: Border.all(color: Color(0xFF2C812A)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Verified Expense',
                      style: TextStyle(color: Colors.black), // Set text color to white
                    ),
                  ),
                ),
              ),
                    ],
                  ),
                  SizedBox(height: 20), // Add space before the button
                ],
              ),
            ),
            Expanded(
              child: _buildItineraryList(),
            ),
            SizedBox(height: 20), // Add space before the button
            Center(
              child: ElevatedButton(
                onPressed: _addItinerary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2C812A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  '+ Add Itinerary',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20), // Add space after the button
          ],
        ),
      ),
    );
  }

 // Inside the _buildItineraryList method
Widget _buildItineraryList() {
  return ListView.builder(
    itemCount: itineraryList.length,
    itemBuilder: (BuildContext context, int index) {
      final item = itineraryList[index];
      return Card(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['Type'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    item['Name'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    item['Address'] ?? '',
                    style: TextStyle(fontSize: 12.0),
                  ),
                  SizedBox(height: 5),
                  Text(
                    item['Date'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItineraryQrPage(
                              itineraryData: item,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFDEE77A),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Expense Validation QR Code',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                      ),
                      value: 'edit',
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                      ),
                      value: 'delete',
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditDialog(context, item, index);
                  } else if (value == 'delete') {
                    _showConfirmationDialog(context, index);
                  }
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

void _showConfirmationDialog(BuildContext context, int index) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this itinerary?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // Remove the item from the itinerary list
                itineraryList.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}


void _showEditDialog(BuildContext context, Map<String, dynamic> item, int index) {
  TextEditingController nameController = TextEditingController(text: item['Name']);
  TextEditingController addressController = TextEditingController(text: item['Address']);
  TextEditingController dateController = TextEditingController(text: item['Date']);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Itinerary'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // Update the item in the itinerary list
                itineraryList[index]['Name'] = nameController.text;
                itineraryList[index]['Address'] = addressController.text;
                itineraryList[index]['Date'] = dateController.text;
              });
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}
}
