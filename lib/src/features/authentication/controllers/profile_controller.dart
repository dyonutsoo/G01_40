import 'package:door_security_lock_app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:door_security_lock_app/src/repository/user_repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/user_model.dart';


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
    getUserData();
  }

  // Function to get user data
  Future<void> getUserData() async {
    final userEmail = _authRepo.firebaseUser.value?.email;
    if (userEmail != null) {
      try {
        // Retrieve user data from the UserRepository
        final userData = await _userRepo.getUserDetails(userEmail);

        // Update the Rx<UserModel?> field with user data
        user.value = userData;

        // Update the TextEditingController fields with user data
        email.text = userData.email;
        fullName.text = userData.fullName;
        phoneNo.text = userData.phoneNo;
      } catch (e) {
        // Handle error when the document is not found or other errors occur
        // You can choose to handle the error as needed, such as creating the document
        // or showing an error message to the user.
        print("Error getting user data: $e");
      }
    } else {
      Get.snackbar("Error", "Login to continue");
    }
  }

  // Function to update user data
  Future<void> updateUserData(UserModel updatedUser) async {
    try {
      // Update the user data in Firestore using the UserRepository
      await _userRepo.updateUserRecord(updatedUser);

      // Update the local user object
      user.value = updatedUser;

      // Update the TextEditingController fields with the updated data
      email.text = updatedUser.email;
      fullName.text = updatedUser.fullName;
      phoneNo.text = updatedUser.phoneNo;
    } catch (e) {
      // Handle error when the update fails
      print("Error updating user data: $e");
    }
  }

}


