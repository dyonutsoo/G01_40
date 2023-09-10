import 'package:door_security_lock_app/src/common_widgets/form/form_header_widget.dart';
import 'package:door_security_lock_app/src/constants/images.dart';
import 'package:door_security_lock_app/src/constants/sizes.dart';
import 'package:door_security_lock_app/src/constants/text.dart';
import 'package:door_security_lock_app/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class ForgetPasswordMailScreen extends StatelessWidget {

  final email = TextEditingController();
  final password = TextEditingController();

  ForgetPasswordMailScreen({super.key});

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
                  subTitle: tForgetMailSubTitle,
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
                          label: Text(tEmail),
                          hintText: tEmail,
                          prefixIcon: Icon(Icons.mail_outline_rounded),

                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text.trim());
                              Get.snackbar(
                                "Success",
                                "Password Reset Email Has Been Sent.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green.withOpacity(0.1),
                                colorText: Colors.green,
                              );
                              Get.to(() => const WelcomeScreen());
                            } catch (e) {
                              // Handle any errors, such as invalid email or user not found.
                              print('Error sending password reset email: $e');
                              // You can display an error message to the user here.
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black87, // Set your desired color here
                          ),
                          child: const Text(tNext),
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

