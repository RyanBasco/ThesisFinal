import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:testing/Expense%20Tracker/Expensetracker.dart';
import 'package:testing/Groups/History.dart';
import 'package:testing/Groups/Travel.dart';
import 'package:testing/TouristDashboard/TouristProfile.dart';
import 'package:testing/TouristDashboard/UserDashboard.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _firstName = '';
  String _lastName = '';
  String _birthday = '';
  String _email = '';
  String _contactNumber = '';
  String? _profileImageUrl;
  File? _profileImage;

  int _selectedIndex = 4;
  bool _isEditing = false;
  bool _showCancelButton = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('Users');
      final DatabaseReference formsRef = FirebaseDatabase.instance.ref().child('Forms');

      // Fetch user data
      final userSnapshot = await usersRef.child(user.uid).get();

      // Fetch forms data directly using the UID
      final formsSnapshot = await formsRef.child(user.uid).get();

      String contactFromForms = '';
      String birthdayFromForms = '';
      if (formsSnapshot.exists) {
        // Debug print to see the forms data
        print('Forms data found: ${formsSnapshot.value}');
        
        final formsData = Map<String, dynamic>.from(formsSnapshot.value as Map);
        
        // Get contact number and birthday from forms
        contactFromForms = formsData['contact_number']?.toString() ?? '';
        birthdayFromForms = formsData['birthday']?.toString() ?? '';
        
        // Debug print the retrieved values
        print('Contact from forms: $contactFromForms');
        print('Birthday from forms: $birthdayFromForms');
      } else {
        print('No forms data found for user: ${user.uid}');
      }

      if (userSnapshot.exists) {
        final userData = Map<String, dynamic>.from(userSnapshot.value as Map);

        setState(() {
          _firstName = userData['first_name'] ?? '';
          _lastName = userData['last_name'] ?? '';
          _birthday = birthdayFromForms;
          _email = user.email ?? '';
          _contactNumber = contactFromForms;
          _profileImageUrl = userData['profile_image_url'];

          // Update the text controllers
          _nameController.text = '$_firstName $_lastName';
          _birthdayController.text = _birthday;
          _emailController.text = _email;
          _contactNumberController.text = _contactNumber;
        });
      }
    } catch (error) {
      print('Failed to fetch user data: $error');
    }
  }
}


  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Crop the image
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: const Color(0xFF288F13),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedImage != null) {
        setState(() {
          _profileImage = File(croppedImage.path);
        });
        await _uploadImageToFirebase(XFile(croppedImage.path));
      }
    }
  }

  Future<void> _uploadImageToFirebase(XFile image) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      String fileName = 'UserProfile/${user.uid}/profile_image/latest_image.jpg'; // Updated path
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(File(image.path));

      String downloadUrl = await ref.getDownloadURL();

      DatabaseReference dbRef = FirebaseDatabase.instance.ref('Users/${user.uid}');
      await dbRef.update({
        'profile_image_url': downloadUrl,
      });

      setState(() {
        _profileImageUrl = downloadUrl;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')),
        );
        Navigator.pop(context, downloadUrl);
      }
    } catch (error) {
      print('Failed to upload image: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image. Please try again.')),
        );
      }
    }
  }
}


  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      _showCancelButton = _isEditing;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _showCancelButton = false;
      _nameController.text = '$_firstName $_lastName';
      _birthdayController.text = _birthday;
      _contactNumberController.text = _contactNumber;
    });
  }

  void _saveChanges() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final ref = FirebaseDatabase.instance.ref().child('Users').child(user.uid);
        var nameParts = _nameController.text.split(' ');
        String firstName = nameParts.length > 1 ? nameParts.sublist(0, nameParts.length - 1).join(' ') : nameParts.isNotEmpty ? nameParts[0] : '';
        String lastName = nameParts.isNotEmpty ? nameParts.last : '';

        await ref.update({
          'first_name': firstName,
          'last_name': lastName,
          'birthday': _birthdayController.text,
          'contact_number': _contactNumberController.text,
        });

        setState(() {
          _firstName = firstName;
          _lastName = lastName;
          _birthday = _birthdayController.text;
          _contactNumber = _contactNumberController.text;
          _isEditing = false;
          _showCancelButton = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (error) {
        print('Failed to update user data: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile. Please try again.')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = DateFormat('MMMM d, yyyy').format(picked);
      });
    }
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    bool enabled = false,
    VoidCallback? onTap,
    TextStyle? textStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 260,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 18),
            child: TextField(
              controller: controller,
              style: textStyle ?? TextStyle(
                color: Colors.grey[700],
                fontSize: 18,
              ),
              enabled: enabled,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              readOnly: onTap != null,
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
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
              Text('Home', style: TextStyle(color: _selectedIndex == 0 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.travel_explore, size: 24, color: _selectedIndex == 1 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Travel', style: TextStyle(color: _selectedIndex == 1 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.attach_money, size: 24, color: _selectedIndex == 2 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Transaction', style: TextStyle(color: _selectedIndex == 2 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 24, color: _selectedIndex == 3 ? const Color(0xFF27AE60) : Colors.grey),
              Text('History', style: TextStyle(color: _selectedIndex == 3 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person, size: 24, color: _selectedIndex == 4 ? const Color(0xFF27AE60) : Colors.grey),
              Text('Profile', style: TextStyle(color: _selectedIndex == 4 ? const Color(0xFF27AE60) : Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
        onTap: (index) {
          _onItemTapped(index);
        },
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 60),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 300,
                  height: 660,
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(top: 40.0, bottom: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 150,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 20,
                              left: 75,
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 55,
                                backgroundImage: _profileImageUrl != null
                                    ? NetworkImage(_profileImageUrl!)
                                    : null,
                                child: _profileImageUrl == null
                                    ? const Icon(Icons.person, color: Colors.white, size: 65)
                                    : null,
                              ),
                            ),
                            Positioned(
                              top: 80,
                              left: 155,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[400],
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10.0,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        labelText: 'Full Name',
                        controller: _nameController,
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        labelText: 'Birthday',
                        controller: _birthdayController,
                        enabled: _isEditing,
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        labelText: 'Email',
                        controller: _emailController,
                        enabled: false,
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        labelText: 'Contact Number',
                        controller: _contactNumberController,
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_showCancelButton)
                            ElevatedButton(
                              onPressed: _cancelEditing,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF288F13),
                              ),
                              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                            ),
                          ElevatedButton(
                            onPressed: _isEditing ? _saveChanges : _toggleEdit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF288F13),
                            ),
                            child: Text(_isEditing ? 'Save Changes' : 'Edit Profile', style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
