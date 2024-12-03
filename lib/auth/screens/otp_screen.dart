import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';

import '../../main.dart'; // Import the email_otp package

class OTPPage extends StatefulWidget {
  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOTPSent = false;
  bool _isOTPVerified = false;
  bool _isLoading = false; // Loader state

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {}); // Update UI when email input changes
    });
  }

  // Method to send OTP with loader
  Future<void> _sendOTP() async {
    if (_emailController.text.trim().isNotEmpty) {
      setState(() {
        _isLoading = true; // Show loader
      });

      bool isSent = await EmailOTP.sendOTP(email: _emailController.text.trim());

      setState(() {
        _isLoading = false; // Hide loader
        _isOTPSent = isSent; // Update OTP sent state
      });

      if (isSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP sent to ${_emailController.text.trim()}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP')),
        );
      }
    }
  }

  // Method to verify OTP with loader
  Future<void> _verifyOTP() async {
    if (_otpController.text.trim().isNotEmpty) {
      setState(() {
        _isLoading = true; // Show loader
      });

      bool isVerified = await EmailOTP.verifyOTP(otp: _otpController.text.trim());

      setState(() {
        _isLoading = false; // Hide loader
      });

      if (isVerified) {
        setState(() {
          _isOTPVerified = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP verified successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email OTP Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email Input
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Enter email'),
            ),
            const SizedBox(height: 16),

            // Send OTP Button
            OutlinedButton(
              onPressed: _emailController.text.trim().isNotEmpty && !_isLoading
                  ? _sendOTP
                  : null, // Disable when loader is active
              child: _isLoading
                  ? const CircularProgressIndicator(
                color: Colors.white, // Show loader in button
              )
                  : const Text('Send OTP'),
            ),
            const SizedBox(height: 16),

            // OTP Input
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'Enter OTP'),
              enabled: _isOTPSent, // Enable OTP input only after OTP is sent
            ),
            const SizedBox(height: 16),

            // Verify OTP Button
            OutlinedButton(
              onPressed: _isOTPSent && _otpController.text.trim().isNotEmpty
                  ? _verifyOTP
                  : null,
              child: Container(
                color: Colors.pink,
                padding: const EdgeInsets.all(12),
                alignment: Alignment.center,
                child: const Text(
                  'Verify OTP',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Global Loading Indicator
            if (_isLoading)
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

