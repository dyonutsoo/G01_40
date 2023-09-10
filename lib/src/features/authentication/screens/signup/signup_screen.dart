import 'package:door_security_lock_app/src/features/authentication/screens/signup/signup_form_widget.dart';
import 'package:flutter/material.dart';
import '../../../../common_widgets/form/form_header_widget.dart';
import '../../../../constants/images.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: const Column(
              children: [
                FormHeaderWidget(
                  image: tWelcomeScreenImage,
                  title: tSignUpTitle,
                  subTitle: tSignUpSubTitle,
                  imageHeight: 0.15,
                ),
                SignUpFormWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}