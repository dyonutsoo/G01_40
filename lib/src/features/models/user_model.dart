import 'package:firebase_database/firebase_database.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  String? profileImageUrl;

  UserModel({
    this.id,
    required this.email,
    required this.fullName,
    required this.phoneNo,
    this.profileImageUrl,
  });

  UserModel.fromSnapshot(DataSnapshot dataSnapshot)
      : id = dataSnapshot.key.toString(),
        email = dataSnapshot.child("Email").value.toString(),
        fullName = dataSnapshot.child("FullName").value.toString(),
        phoneNo = dataSnapshot.child("Phone").value.toString(),
        profileImageUrl = dataSnapshot.child("profileImageUrl").value.toString();


  Map<String, dynamic> toMap() {
    return {
      "FullName": fullName,
      "Email": email,
      "Phone": phoneNo,
      "profileImageUrl": profileImageUrl,
    };
  }

  // Create a factory constructor to create a UserModel from a Map
  factory UserModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return UserModel(
      email: map["Email"],
      fullName: map["FullName"],
      phoneNo: map["Phone"],
      profileImageUrl: map["profileImageUrl"],
    );
  }

  void updateProfileImageUrl(String imageUrl) {
    profileImageUrl = imageUrl;
  }
}
