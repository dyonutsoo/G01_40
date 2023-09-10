import 'package:door_security_lock_app/src/features/authentication/screens/login/login_form_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MailVerificationController extends GetxController {
  Future<void> checkEmailVerificationStatus(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      // Email is verified, navigate to the login page
      Get.offAll(() => LoginFormWidget());
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();

      // Show a message indicating that the email has been sent
      Get.snackbar(
        "Email Sent",
        "A verification email has been sent to your email address.",
      );
    } catch (e) {
      // Handle errors (e.g., user is not signed in)
      print("Error resending verification email: $e");
      Get.snackbar(
        "Error",
        "Failed to resend the verification email. Please try again later.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class MailVerification extends StatelessWidget {
  const MailVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MailVerificationController());

    // Call the checkEmailVerificationStatus when the page is first loaded
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.checkEmailVerificationStatus(context);
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.email, size: 100),
                const SizedBox(height: 16.0),
                Text("Email Verification", style: Theme.of(context).textTheme.headline6),
                const SizedBox(height: 16.0),
                Text(
                  "Please click the button for a verification link.",
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 200,
                  child: OutlinedButton(
                    onPressed: () => controller.resendVerificationEmail(),
                    child: const Text("Send Email Link"),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    // Navigate back to the previous page (could be the login page)
                    Get.back();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_left),
                      SizedBox(width: 5),
                      Text("Back"),
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
