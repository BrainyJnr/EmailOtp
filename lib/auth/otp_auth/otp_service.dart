import 'package:email_otp/email_otp.dart';


class OTPService {
  // Send OTP
  static Future<bool> sendOTP(String email) async {
    try {
      bool isSent = await EmailOTP.sendOTP(email: email); // Adjust here
      return isSent;
    } catch (e) {
      print("Error sending OTP: $e");
      return false;
    }
  }

  static Future<bool> verifyOTP(String recipientMail, String otp) async {
    try {
      bool isVerified = await EmailOTP.verifyOTP(
        otp: otp,             // Adjusted parameter
      );
      return isVerified;
    } catch (e) {
      print("Error verifying OTP: $e");
      return false;
    }
  }
}
