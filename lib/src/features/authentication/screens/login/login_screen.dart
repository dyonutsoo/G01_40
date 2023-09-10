import 'package:door_security_lock_app/src/common_widgets/form/form_header_widget.dart';
import 'package:door_security_lock_app/src/constants/images.dart';
import 'package:door_security_lock_app/src/constants/sizes.dart';
import 'package:door_security_lock_app/src/constants/text.dart';
import 'package:flutter/material.dart';
import 'login_form_widget.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                const FormHeaderWidget(
                  image: tWelcomeScreenImage,
                  title: tLoginTitle,
                  subTitle: tLoginSubTitle,
                ),
                LoginFormWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


