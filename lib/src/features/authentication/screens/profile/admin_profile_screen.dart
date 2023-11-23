import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/images.dart';
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

  String? adminEmail;
  String? adminFullName;
  String? adminPhone;

  final adminEmailController = TextEditingController();
  final adminFullNameController = TextEditingController();
  final adminPhoneController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    loadAdminData();
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final user = _auth.currentUser;
      if (user != null) {
        final currentUserEmail = user.email;
        final storageReference = FirebaseStorage.instance.ref().child('Admin_profile_images/$currentUserEmail.jpg');

        // Upload the image to Firebase Storage
        await storageReference.putFile(File(pickedFile.path));

        // Get the download URL of the uploaded image
        final imageUrl = await storageReference.getDownloadURL();

        // Update the Realtime Database with the new image URL
        final DatabaseReference adminRef = FirebaseDatabase.instance.reference().child('Admin');
        await adminRef.child('AdminProfileImage').set(imageUrl);

        setState(() {
          profileImageUrl = imageUrl;
        });
      }
    }
  }

  Future<void> loadAdminData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final currentUserEmail = user.email;

      // Create a reference to the "Admin" node in the Realtime Database.
      final DatabaseReference adminRef = FirebaseDatabase.instance.reference().child('Admin'); // Update this line

      adminRef.onValue.listen((event) {
        final snapshot = event.snapshot;
        final Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?; // Cast the value to a map

        if (data != null) {
          adminEmail = data['AdminEmail'];
          adminFullName = data['AdminFullName'];
          adminPhone = data['AdminPhone'];
          profileImageUrl = data['AdminProfileImage'];

          setState(() {
            adminEmailController.text = adminEmail ?? '';
            adminFullNameController.text = adminFullName ?? '';
            adminPhoneController.text = adminPhone ?? '';
          });
        }
      });
    }
  }

  Future<void> updateAdminProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final currentUserEmail = user.email;

      // Create a reference to the "Admin" node in the Realtime Database.
      final DatabaseReference adminRef = FirebaseDatabase.instance.reference().child('Admin');

      // Update the values from the text fields.
      adminEmail = adminEmailController.text;
      adminFullName = adminFullNameController.text;
      adminPhone = adminPhoneController.text;

      // Update the Realtime Database with the new values.
      final updateData = {
        'AdminEmail': adminEmail,
        'AdminFullName': adminFullName,
        'AdminPhone': adminPhone,
      };

      await adminRef.update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Admin\'s Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                children: [
                  GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: profileImageUrl != null
                          ? Image.network(profileImageUrl!, fit: BoxFit.cover)
                          : Image.asset(tProfileImage, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,),
                      ),
                    ),
                  ),
                ],
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
                child: const Text("Save Profile"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
                    child: Text("Are you sure you want to Logout?"),
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