import 'package:door_security_lock_app/firebase_options.dart';
import 'package:door_security_lock_app/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:door_security_lock_app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:door_security_lock_app/src/features/authentication/controllers/profile_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthenticationRepository());
  Get.put(ProfileController()); // Register ProfileController
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Door Security Lock App',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 500),
      home: SplashScreen(),
    );
  }
}