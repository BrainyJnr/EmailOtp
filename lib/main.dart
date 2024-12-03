import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

import 'auth/otp_auth/reset password.dart';
import 'auth/screens/otp_screen.dart';

void main() {
  // Configure OTP Service
  EmailOTP.config(
    appName: 'MyApp',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v1,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.pink, // Text color
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Adjust padding
          ),
        ),
      ),
      home:  OTPPage(),
    );
  }
}



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: const Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isOTPSent = false;


  // Method to simulate sending OTP to email
  Future<void> _sendOTP(String email) async {
    bool isSent = await EmailOTP.sendOTP(email: email);  // Send OTP
    if (isSent) {
      setState(() {
        _isOTPSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP sent to $email')));

      // Navigate to OTPPages and pass the email for verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OTPPages(email: email),  // Pass the email
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send OTP')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email Input
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Send OTP Button
              GestureDetector(
              onTap: _emailController.text.trim().isNotEmpty
                  ? () => _sendOTP(_emailController.text.trim())
                  : null,
              child: Container(
                color: Colors.pink,
                padding: const EdgeInsets.all(12),
                alignment: Alignment.center,
                child: const Text(
                  'Send OTP',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class OTPPages extends StatefulWidget {
  final String email;

  const OTPPages({super.key, required this.email});

  @override
  _OTPPagesState createState() => _OTPPagesState();
}

class _OTPPagesState extends State<OTPPages> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isOTPVerified = false;
  bool _isOTPSent = false;


  // Method to simulate OTP validation
  Future<void> _verifyOTP(String otp) async {
    setState(() {
      _isLoading = true; // Show loading indicator during OTP verification
    });

    // Assuming EmailOTP.verifyOTP(otp) is a valid function for verifying the OTP
    bool isVerified = await EmailOTP.verifyOTP(otp: otp);

    setState(() {
      _isLoading = false; // Hide loading indicator after verification attempt
    });

    if (isVerified) {
      setState(() {
        _isOTPVerified = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP verified successfully')));

      // Navigate to ResetPasswordScreen after OTP verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: widget.email)),  // Pass email from widget
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP. Please try again')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // OTP Input
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                labelStyle: TextStyle(color: Colors.brown),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                border: OutlineInputBorder(),
              ),
             // enabled: _isOTPSent,
            ),
            const SizedBox(height: 16),

            // Verify OTP Button
            InkWell(
              onTap: _otpController.text.trim().isNotEmpty
                  ? () => _verifyOTP(_otpController.text.trim())
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

          ],
        ),
      ),
    );
  }
}

