import 'package:door_security_lock_app/src/common_widgets/fade_in_animation/animation_design.dart';
import 'package:door_security_lock_app/src/common_widgets/fade_in_animation/fade_in_animation_controller.dart';
import 'package:door_security_lock_app/src/common_widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:door_security_lock_app/src/constants/colors.dart';
import 'package:door_security_lock_app/src/constants/images.dart';
import 'package:door_security_lock_app/src/constants/sizes.dart';
import 'package:door_security_lock_app/src/constants/text.dart';
import 'package:door_security_lock_app/src/features/authentication/screens/login/login_screen.dart';
import 'package:door_security_lock_app/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInAnimationController());
    controller.startAnimation();

    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;

    return Scaffold(
      body: Stack(
        children: [
          TFadeInAnimation(
            durationInMs: 1200,
            animate: TAnimatePosition(
                bottomAfter: 0,
                bottomBefore: -100,
                leftBefore: 0,
                leftAfter: 0,
                topAfter: 0,
                topBefore: 0,
                rightAfter: 0,
                rightBefore: 0,
            ),
            child: Container(
              padding: const EdgeInsets.all(tDefaultSize),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Image(image: const AssetImage(tWelcomeScreenImage), height: height * 0.35),
                Column(
                  children: [
                    Text(
                      tWelcomeTitle,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      tWelcomeSubTitle,
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () => Get.to(() => const LoginScreen()),
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              foregroundColor: tSecondaryColor,
                              side: const BorderSide(color: tSecondaryColor),
                              padding: const EdgeInsets.symmetric(vertical: tButtonHeight),
                            ),
                            child: Text(tLogin.toUpperCase()),
                        ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: ()  => Get.to(() => const SignUpScreen()),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const RoundedRectangleBorder(),
                            foregroundColor: tWhiteColor,
                            backgroundColor: tSecondaryColor,
                            side: const BorderSide(color: tSecondaryColor),
                            padding: const EdgeInsets.symmetric(vertical: tButtonHeight),
                          ),
                            child: Text(tSignup.toUpperCase()),
                        ),
                    ),
                  ],
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
