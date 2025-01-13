import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/Groups/History.dart';
import 'package:testing/Groups/QRCodeDisplayPage.dart';
import 'package:testing/Groups/SelectGroupPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class GroupQRCodePage extends StatelessWidget {
  final String groupId;
  final List<Map<String, dynamic>> selectedUsers;
  final ScreenshotController screenshotController = ScreenshotController();
  int _selectedIndex = 1;

  GroupQRCodePage({required this.groupId, this.selectedUsers = const []});

  Future<void> _saveQrToGallery(BuildContext context) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final Uint8List? image = await screenshotController.capture();

      if (image != null) {
        final result = await SaverGallery.saveImage(
          image,
          quality: 100,
          fileName: "QR_Code_${DateTime.now().millisecondsSinceEpoch}",
          skipIfExists: false,
        );

        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("QR code saved to gallery!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to save QR code.")),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission denied.")),
      );
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    Widget page = Container();
    switch (index) {
      case 0:
        page = UserdashboardPageState();
        break;
      case 1:
        return;
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
      body: Screenshot(
        controller: screenshotController,
        child: Container(
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
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF288F13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Regroup',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Group Mode',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF114F3A),
                        ),
                      ),
                      const SizedBox(height: 20),
                      QrImageView(
                        data: groupId,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                      const SizedBox(height: 20),
                      // Display selected users
                      if (selectedUsers.isNotEmpty)
                        Column(
                          children: selectedUsers.map((user) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(user['name'] ?? 'Unnamed User'),
                            );
                          }).toList(),
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRCodeDisplayPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF288F13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Switch to Individual',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _saveQrToGallery(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF288F13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save QR Code',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFF51F643),
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 65,
        index: _selectedIndex,
        animationDuration: const Duration(milliseconds: 333),
        animationCurve: Curves.easeInOut,
        items: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home, size: 24, color: _selectedIndex == 0 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Home', style: TextStyle(color: _selectedIndex == 0 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.travel_explore, size: 24, color: _selectedIndex == 1 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Travel', style: TextStyle(color: _selectedIndex == 1 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.attach_money, size: 24, color: _selectedIndex == 2 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Transaction', style: TextStyle(color: _selectedIndex == 2 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 24, color: _selectedIndex == 3 ? const Color(0xFF27AE60) : Colors.grey),
              Text('History', style: TextStyle(color: _selectedIndex == 3 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person, size: 24, color: _selectedIndex == 4 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Profile', style: TextStyle(color: _selectedIndex == 4 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10)),
            ],
          ),
        ],
        onTap: (index) {
          _selectedIndex = index;
          _onItemTapped(context, index);
        },
      ),
    );
  }
}
