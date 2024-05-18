import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF114F3A),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF114F3A),
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormFieldWithIcon('Last Name', Icons.person),
              TextFormFieldWithIcon('First Name', Icons.person),
              GestureDetector(
                onTap: () {
                  // Show date picker
                  _selectDate(context);
                },
                child: TextFormFieldWithIcon('Birthday', Icons.calendar_today),
              ),
              TextFormFieldWithIcon('Username', Icons.person),
              TextFormFieldWithIcon('Email', Icons.email),
              TextFormFieldWithIcon('Password', Icons.lock),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle sign up button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2C812A), // Changed button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(200, 50), // Set minimum button size
                ),
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigate to login page
                },
                child: Text(
                  'Already have an account yet? Log In',
                  style: TextStyle(
                    color: Color(0xFF2D60F7), // Blue color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      // Do something with the selected date
    }
  }
}

class TextFormFieldWithIcon extends StatelessWidget {
  final String hintText;
  final IconData iconData;

  const TextFormFieldWithIcon(this.hintText, this.iconData);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF5CA14E), // Change field color
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              iconData,
              color: Colors.white, // Change icon color
            ),
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.white), // Change hint text color
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
