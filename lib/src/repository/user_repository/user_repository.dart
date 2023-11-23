import 'package:firebase_database/firebase_database.dart';
import 'package:door_security_lock_app/src/features/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseDatabase.instance.ref().child('Users');

  Future<void> createUser(UserModel user) async {
    // Remove the "Password" field from the user data
    final userData = user.toMap()..remove("Password");

    final userRef = _db.child("Users").push(); // Generate a unique key for the user
    userRef.set(userData).then((_) {
      Get.snackbar(
        "Success",
        "Your account has been created.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    }).catchError((error) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
  }

  Future<UserModel?> getUserDetails(String userId) async {
    try {
      final query = _db.child("Users").child(userId); // Query by UID

      final event = await query.once();
      final userMap = event.snapshot.value as Map<dynamic, dynamic>?;

      if (userMap != null) {
        final user = UserModel.fromSnapshot(event.snapshot);
        return user;
      }

      return null; // Return null if no data was found
    } catch (error) {
      // Handle errors
      Get.snackbar("Error", "Failed to fetch user data. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
      return null;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    final dataSnapshot = await _db.once() as DataSnapshot;
    if (dataSnapshot.value is Map) {
      final usersData = dataSnapshot.value as Map<dynamic, dynamic>;
      final users = usersData.entries
          .map((entry) => UserModel.fromMap(entry.key, entry.value))
          .toList();
      return users;
    }
    return [];
  }



  Future<void> deleteUser(String userId) async {
    try {
      await _db.child("Users").child(userId).remove();

      Get.snackbar(
        "Success",
        "User has been deleted.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Failed to delete the user. Try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString());
    }
  }

  Future<void> updateUserRecord(UserModel updatedUser, String userId) async {
    try {
      final userRef = _db.child("Users").child(userId);

      final userData = {
        "Email": updatedUser.email,
        "FullName": updatedUser.fullName,
        "Phone": updatedUser.phoneNo,
        "profileImageUrl": updatedUser.profileImageUrl,
      };

      await userRef.update(userData);

      Get.snackbar(
        "Success",
        "User data has been updated.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Failed to update user data. Try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString());
    }
  }


  Future<UserModel?> getUserData(String email) async {
    try {
      final query = _db.child("Users").orderByChild("Email").equalTo(email);

      final event = await query.once();
      final userMap = event.snapshot.value as Map<dynamic, dynamic>?;

      if (userMap != null) {
        final user = UserModel.fromSnapshot(event.snapshot);
        return user;
      }

      return null; // Return null if no user data was found
    } catch (error) {
      // Handle errors
      Get.snackbar("Error", "Failed to fetch user data. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
      return null;
    }
  }

}
