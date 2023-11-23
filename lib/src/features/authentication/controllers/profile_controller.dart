import 'package:door_security_lock_app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:door_security_lock_app/src/repository/user_repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  final user = Rx<UserModel?>(null);
  final email = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    //fetchAndDisplayUserData();
  }

  /*Future<void> fetchAndDisplayUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userData = await _userRepo.getUserDetails(currentUser.uid);
        if (userData != null) {
          // Update the user object and TextFormFields with the user's information
          user.value = userData;
          email.text = userData.email;
          fullName.text = userData.fullName;
          phoneNo.text = userData.phoneNo;
        }
      }
    } catch (e) {
      // Handle error when fetching user data fails
      print("Error fetching user data: $e");
    }
  }
*/

  Future<void> updateUserData(UserModel updatedUser) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userId = currentUser.uid;

        // Create a Map with the updated user data
        final updatedUserData = {
          "Email": updatedUser.email,
          "FullName": updatedUser.fullName,
          "Phone": updatedUser.phoneNo,
          "profileImageUrl": updatedUser.profileImageUrl,
        };

        //await _userRepo.updateUserRecord(updatedUser, userId);

        // Update the local user object
        user.value = updatedUser;

        // Update the TextEditingController fields with the updated data
        email.text = updatedUser.email;
        fullName.text = updatedUser.fullName;
        phoneNo.text = updatedUser.phoneNo;
      }
    } catch (e) {
      // Handle error when the update fails
      print("Error updating user data: $e");
    }
  }
}