import 'package:firebase_database/firebase_database.dart';
import 'package:door_security_lock_app/src/features/authentication/screens/dashboard/dashboard.dart';
import 'package:door_security_lock_app/src/features/authentication/screens/mail_verification/mail_verification.dart';
import 'package:door_security_lock_app/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:door_security_lock_app/src/repository/authentication_repository/exception/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import '../../features/authentication/screens/dashboard/admin_dashboard.dart';
import 'exception/login_email_password.dart';
import 'exception/signup_email_password.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    FlutterNativeSplash.remove();
    setInitialScreen(firebaseUser.value);
    //ever(firebaseUser, _setInitialScreen);
  }

  setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => const WelcomeScreen());
    } else if (user.emailVerified) {
      final userEmail = user.email ?? ''; // Ensure userEmail is not null
      if (await isAdmin(userEmail)) {
        Get.offAll(() => AdminDashboard()); // Redirect admin to admin dashboard
      } else {
        Get
            .offAll(() => const Dashboard()); // Regular user goes to the user dashboard
      }
    } else {
      Get.offAll(() => const MailVerification());
    }
  }


  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId.value = verificationId;
      },
      verificationFailed: (e) {
        if (e.code == 'invalid phone number') {
          Get.snackbar('Error', 'The provided phone number is not valid.');
        } else {
          Get.snackbar('Error', 'Something went wrong. Try again.');
        }
      },
    );
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }

  Future<String?> createUserWithEmailAndPassword(String email,
      String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => const Dashboard())
          : Get.to(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      return ex.message;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }

  Future<String?> loginWithEmailAndPassword(
      String email, String password, {bool isAdmin = false}) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return "Email and password are required.";
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (isAdmin) {
        // Handle admin login specific logic here
      }

    } on FirebaseAuthException catch (e) {
      final ex = LogInWithEmailAndPasswordFailure.code(e.code);
      return ex.message;
    } catch (_) {
      const ex = LogInWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }



  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = TExceptions();
      throw ex.message;
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Unable to logout. Try again.';
    }
  }

  Future<bool> isAdmin(String email) async {
    try {
      final adminReference = FirebaseDatabase.instance.reference().child('Admin').child('AdminEmail');

      DatabaseEvent event = await adminReference.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        String adminEmail = snapshot.value as String;

        return adminEmail == email;
      }
    } catch (e) {
      // Handle errors if the data retrieval fails
      print("Error checking admin status: $e");
    }
    return false;
  }


}





