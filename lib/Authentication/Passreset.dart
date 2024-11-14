import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManualPasswordResetPage extends StatefulWidget {
  const ManualPasswordResetPage({Key? key}) : super(key: key);

  @override
  _ManualPasswordResetPageState createState() => _ManualPasswordResetPageState();
}

class _ManualPasswordResetPageState extends State<ManualPasswordResetPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Manually triggers Firebase to send a password reset email
  Future<void> manualSendPasswordReset() async {
    String email = _emailController.text.trim();
    
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showMessage("Password reset email sent to $email");
    } on FirebaseAuthException catch (e) {
      _showMessage("Error: ${e.message}");
    }
  }

  // Helper function to show messages in a dialog
  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manual Password Reset")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: manualSendPasswordReset,
              child: const Text("Send Password Reset Email"),
            ),
          ],
        ),
      ),
    );
  }
}
