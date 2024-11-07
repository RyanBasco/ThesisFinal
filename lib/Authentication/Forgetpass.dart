import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing/Authentication/Passreset.dart';

class PhoneAuthPage extends StatefulWidget {
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? _verificationId;
  bool _isOtpSent = false;

  Future<void> _sendOtp() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically verify and sign in
        await _auth.signInWithCredential(credential);
        _showPasswordReset();
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isOtpSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP sent to your phone")),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _verifyOtp() async {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _otpController.text.trim(),
    );

    try {
      await _auth.signInWithCredential(credential);
      _showPasswordReset();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP: $e")),
      );
    }
  }

  void _showPasswordReset() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordResetPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Authentication")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _isOtpSent
                ? TextField(
                    controller: _otpController,
                    decoration: const InputDecoration(
                      labelText: 'OTP',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  )
                : Container(),
            const SizedBox(height: 20),
            _isOtpSent
                ? ElevatedButton(
                    onPressed: _verifyOtp,
                    child: const Text("Verify OTP"),
                  )
                : ElevatedButton(
                    onPressed: _sendOtp,
                    child: const Text("Send OTP"),
                  ),
          ],
        ),
      ),
    );
  }
}
