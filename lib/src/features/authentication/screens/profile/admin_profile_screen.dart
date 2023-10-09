import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/text.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../forget_password/forget_password_mail/forget_password_mail.dart';
import 'profile_menu.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? adminEmail;
  String? adminFullName;
  String? adminPhone;

  final adminEmailController = TextEditingController();
  final adminFullNameController = TextEditingController();
  final adminPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAdminData();
  }

  Future<void> loadAdminData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final currentUserEmail = user.email;
      final adminDoc = await _firestore.collection("Admin").doc("Admin").get();

      if (adminDoc.exists) {
        adminEmail = adminDoc.get("AdminEmail");
        adminFullName = adminDoc.get("AdminFullName");
        adminPhone = adminDoc.get("AdminPhone");
      }

      setState(() {
        adminEmailController.text = adminEmail ?? '';
        adminFullNameController.text = adminFullName ?? '';
        adminPhoneController.text = adminPhone ?? '';
      });
    }
  }

  // Add a function to update the admin profile
  Future<void> updateAdminProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final currentUserEmail = user.email;

      // Update the values from the text fields
      adminEmail = adminEmailController.text;
      adminFullName = adminFullNameController.text;
      adminPhone = adminPhoneController.text;

      // Update the Firestore document with the new values
      await _firestore.collection("Admin").doc("Admin").update({
        "AdminEmail": adminEmail,
        "AdminFullName": adminFullName,
        "AdminPhone": adminPhone,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 30, left: 20, right: 20), // Adjust the margins as needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Admin's Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const Image(
                  image: AssetImage('images/dashboard/profile_pic.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            TextFormField(
              controller: adminFullNameController,
              decoration: const InputDecoration(
                labelText: tFullName,
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextFormField(
              controller: adminEmailController,
              decoration: const InputDecoration(
                labelText: tEmail,
                prefixIcon: Icon(Icons.email),
              ),
            ),
            TextFormField(
              controller: adminPhoneController,
              decoration: const InputDecoration(
                labelText: tPhoneNo,
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  updateAdminProfile();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: tSecondaryColor,
                  foregroundColor: tWhiteColor,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
                child: const Text("Edit Profile"),
              ),
            ),
            const Divider(),
            ProfileMenuWidget(
              title: "Settings",
              icon: Icons.settings,
              onPress: () {},
            ),
            const Divider(),
            ProfileMenuWidget(
              title: "Change Password",
              icon: Icons.lock,
              onPress: () {
                Get.to(() => ForgetPasswordMailScreen());
              },
            ),
            const Divider(),
            const SizedBox(height: 10),
            ProfileMenuWidget(
              title: "Logout",
              icon: Icons.exit_to_app,
              textColor: Colors.red,
              endIcon: false,
              onPress: () {
                Get.defaultDialog(
                  title: "LOGOUT",
                  titleStyle: const TextStyle(fontSize: 20),
                  content: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text("Are you sure, you want to Logout?"),
                  ),
                  confirm: Expanded(
                    child: ElevatedButton(
                      onPressed: () => AuthenticationRepository.instance.logout(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        side: BorderSide.none,
                      ),
                      child: const Text("Yes"),
                    ),
                  ),
                  cancel: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text("No"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
