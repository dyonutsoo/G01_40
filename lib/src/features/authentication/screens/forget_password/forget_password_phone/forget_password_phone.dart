import 'package:door_security_lock_app/src/common_widgets/form/form_header_widget.dart';
import 'package:door_security_lock_app/src/constants/images.dart';
import 'package:door_security_lock_app/src/constants/sizes.dart';
import 'package:door_security_lock_app/src/constants/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../welcome/welcome_screen.dart';

class ForgetPasswordPhoneScreen extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();
  final newPassword = TextEditingController(); // Add a new controller for the new password

  ForgetPasswordPhoneScreen({super.key});

  void handleChangePassword(BuildContext context) {
    // Implement your password change logic here
    String oldEmail = email.text;
    String oldPassword = password.text;
    String newPass = newPassword.text;

    // Example: You can print the old email, old password, and new password for now
    print("Old Email: $oldEmail");
    print("Old Password: $oldPassword");
    print("New Password: $newPass");

    // Replace the above logic with your actual password change code
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                const SizedBox(height: tDefaultSize * 4),
                const FormHeaderWidget(
                  image: tForgetPasswordImage,
                  title: tForgetPassword,
                  subTitle: tForgetPhoneSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: tFormHeight),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                          label: Text(tPhoneNo),
                          hintText: tPhoneNo,
                          prefixIcon: Icon(Icons.mobile_friendly_rounded),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: newPassword,
                        obscureText: true, // Hide the new password
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          hintText: 'Enter your new password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            handleChangePassword(context); // Call the password change function
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black87,
                          ),
                          child: const Text('Change Password'), // Update button text
                        ),
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
