import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing/TouristDashboard/QrPage.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Map<String, dynamic>> _bookmarkedItems = [];
  int _selectedIndex = 3;
  String _selectedCategory = "";

  @override
  void initState() {
    super.initState();
    _fetchBookmarkedItems();
  }

  void _fetchBookmarkedItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        var querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Bookmarks')
            .get();

        setState(() {
          _bookmarkedItems = querySnapshot.docs
              .map((doc) => {
                    'id': doc.id,
                    ...doc.data(),
                  })
              .toList();
        });
      } catch (error) {
        print('Failed to fetch bookmarked items: $error');
      }
    }
  }

  void _showConfirmationDialog(String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove from bookmarks'),
          content: const Text('Are you sure you want to remove this item from bookmarks?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeBookmarkedItem(docId);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _removeBookmarkedItem(String docId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Bookmarks')
            .doc(docId)
            .delete();

        setState(() {
          _bookmarkedItems.removeWhere((item) => item['id'] == docId);
        });
      } catch (error) {
        print('Failed to delete bookmarked item: $error');
      }
    }
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
        break;
    }
  }

  void _onCategoryTap(String category) {
    setState(() {
      _selectedCategory = _selectedCategory == category ? "" : category;
    });
  }

  Widget _buildCategoryBox(String category) {
    bool isSelected = _selectedCategory == category;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onCategoryTap(category),
        child: Container(
          margin: const EdgeInsets.only(right: 15),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2C812A) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkedItem(Map<String, dynamic> item) {
  // Get the image path, default to null if not present
  String? imagePath = item['imagePath'];
  String title = item['title'] ?? 'No Title';
  String location = item['location'] ?? 'No Location';

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    child: Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: imagePath != null && imagePath.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 55, // Adjust size as needed
                    backgroundColor: Colors.grey.shade300,
                    child: Text(
                      title.isNotEmpty ? title[0].toUpperCase() : '?', // Use the first letter of the title
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showConfirmationDialog(item['id']),
          ),
        ],
      ),
    ),
  );
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
            stops: [0.15, 0.45, 0.75],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Text(
                      'My Bookmarks',
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C812A),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildCategoryBox('Places'),
                  const SizedBox(width: 5),
                  _buildCategoryBox('Food'),
                  const SizedBox(width: 5),
                  _buildCategoryBox('Other'),
                ],
              ),
            ),
            Expanded(
              child: _bookmarkedItems.isEmpty
                  ? const Center(child: Text('No Bookmarks Found'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _bookmarkedItems
                            .map((item) => _buildBookmarkedItem(item))
                            .toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
