import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:door_security_lock_app/src/features/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    // Remove the "Password" field from the user data
    final userData = user.toJson()..remove("Password");

    await _db.collection("Users").add(userData).whenComplete(() {
      Get.snackbar(
        "Success",
        "Your account has been created.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    }).catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
    await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>?> getAllUsers() async {
    try {
      final snapshot = await _db.collection("Users").get();
      final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
      return userData;
    } catch (error) {
      Get.snackbar("Error", "Failed to fetch user data. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
      return null;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();

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

  Future<void> updateUserRecord(UserModel updatedUser) async {
    final userDoc = _db.collection("Users").doc(updatedUser.id);
    await userDoc.update(updatedUser.toJson());
  }

  getUserData(String email) {}
}
