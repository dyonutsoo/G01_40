import 'package:door_security_lock_app/src/constants/sizes.dart';
import 'package:door_security_lock_app/src/constants/text.dart';
import 'package:door_security_lock_app/src/features/authentication/screens/forget_password/forget_password_options/forget_password_model_bottom_sheet.dart';
import 'package:door_security_lock_app/src/features/authentication/screens/mail_verification/mail_verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../signup/signup_screen.dart';


class LoginFormWidget extends StatefulWidget {
  LoginFormWidget({Key? key}) : super(key: key);

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;

  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        // Check if the user's email is verified
        if (userCredential.user!.emailVerified) {
          // Successfully logged in and email is verified, navigate to the dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  SignUpScreen()),
          );
        } else {
          // Email is not verified, navigate to the MailVerification page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MailVerification()),
          );
        }
      }
    } catch (e) {
      // Handle login errors here (e.g., show an error message)
      print("Error during login: $e");

      // Show a SnackBar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login failed. Please check your credentials."),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: tEmail,
                hintText: tEmail,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint),
                labelText: "Password",
                hintText: "Enter your password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
            const SizedBox(height: tFormHeight - 20),

            // -- Forget Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ForgetPasswordScreen.buildShowModalBottomSheet(context);
                },
                child: const Text(tForgetPassword),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _login(context); // Pass the context when calling the login function
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black87, // Set your desired color here
                ),
                child: Text(tLogin.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

