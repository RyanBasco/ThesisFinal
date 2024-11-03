import 'package:flutter/material.dart';

void main() {
  runApp(TouristServiceApp());
}

class TouristServiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TouristServiceSelection(),
    );
  }
}

class TouristServiceSelection extends StatefulWidget {
  @override
  _TouristServiceSelectionState createState() => _TouristServiceSelectionState();
}

class _TouristServiceSelectionState extends State<TouristServiceSelection> {
  int _currentScreen = 0; // 0 = Welcome, 1 = Selection, 2 = Review, 3 = Confirmation
  List<String> _selectedServices = [];

  // Services list
  final List<String> _services = [
    "Accommodation",
    "Food and Beverages",
    "Transportation",
    "Attractions and Activities",
    "Shopping",
    "Entertainment",
    "Wellness and Spa Services",
    "Adventure and Outdoor Activities",
    "Travel Insurance",
    "Local Tours and Guides"
  ];

  // Navigate to a specific screen
  void _showScreen(int screenIndex) {
    setState(() {
      _currentScreen = screenIndex;
    });
  }

  // Update selected services for review
  void _updateSelectedServices(List<String> selected) {
    setState(() {
      _selectedServices = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: _buildCurrentScreen(),
          ),
        ),
      ),
    );
  }

  // Build the appropriate screen based on _currentScreen
  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case 0:
        return _buildWelcomeScreen();
      case 1:
        return _buildSelectionScreen();
      case 2:
        return _buildReviewScreen();
      case 3:
        return _buildConfirmationScreen();
      default:
        return _buildWelcomeScreen();
    }
  }

  Widget _buildWelcomeScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Select Offers for Your Tourists",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _showScreen(1),
          child: const Text("Choose Services for Tourists"),
        ),
      ],
    );
  }

  Widget _buildSelectionScreen() {
    return Column(
      children: [
        const Text(
          "Select Your Services for Tourists",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text("Choose the services you offer that will enhance tourists' experiences."),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            children: _services.map((service) {
              return CheckboxListTile(
                title: Text(service),
                value: _selectedServices.contains(service),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedServices.add(service);
                    } else {
                      _selectedServices.remove(service);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _updateSelectedServices(_selectedServices);
            _showScreen(2);
          },
          child: const Text("Next"),
        ),
      ],
    );
  }

  Widget _buildReviewScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Review Tourist Services",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text("Review the services selected for tourists. Click 'Save' to confirm or 'Back' to make changes."),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            children: _selectedServices.map((service) {
              return ListTile(
                title: Text(service),
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _showScreen(1),
              child: const Text("Back"),
            ),
            ElevatedButton(
              onPressed: () => _showScreen(3),
              child: const Text("Save"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmationScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Success!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text("Your services for tourists have been successfully saved!"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _showScreen(0),
          child: const Text("Go to Dashboard"),
        ),
      ],
    );
  }
}
