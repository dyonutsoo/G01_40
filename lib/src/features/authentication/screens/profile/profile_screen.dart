import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../constants/colors.dart';
import '../../../../constants/images.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../../../../repository/user_repository/user_repository.dart';
import '../../../models/user_model.dart';
import 'profile_menu.dart';
import 'update_profile_screen.dart';
import '../forget_password/forget_password_mail/forget_password_mail.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  ImagePicker _imagePicker = ImagePicker();
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    loadUserData(); // Load user data when the screen is initialized
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final currentUserEmail = user.email;

      final DatabaseReference usersRef =
      FirebaseDatabase.instance.reference().child('Users');

      usersRef.onValue.listen((event) async {
        final snapshot = event.snapshot;
        final Map<dynamic, dynamic>? data =
        snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          final List<UserModel> loadedUsers = data.entries
              .map((entry) => UserModel.fromMap(entry.key, entry.value))
              .toList();

          final UserModel? currentUser = loadedUsers.firstWhere(
                (user) => user.email == currentUserEmail,
          );

          if (currentUser != null) {
            setState(() {
              this.user = currentUser;
              // Update the text controllers with user data
              fullNameController.text = currentUser.fullName;
              emailController.text = currentUser.email;
              phoneNoController.text = currentUser.phoneNo;
              profileImageUrl = currentUser.profileImageUrl;
            });
          }
        }
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final currentUserEmail = user.email;

        if (currentUserEmail != null) {
          final storageReference =
          FirebaseStorage.instance.ref().child('Users_profile_images/$currentUserEmail.jpg');

          // Upload the image to Firebase Storage
          await storageReference.putFile(File(pickedFile.path));

          // Get the download URL of the uploaded image
          final imageUrl = await storageReference.getDownloadURL();

          // Update the Realtime Database with the new image URL
          final DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('Users');
          await userRef
              .child(currentUserEmail.replaceAll('.', '_'))
              .child('UsersProfileImage')
              .set(imageUrl);

          setState(() {
            profileImageUrl = imageUrl;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          tProfile,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: _pickAndUploadImage,
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: profileImageUrl != null
                            ? Image.network(profileImageUrl!, fit: BoxFit.cover)
                            : Image.asset(tProfileImage, fit: BoxFit.cover),
                      ),
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
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        labelText: tFullName,
                        prefixIcon: Icon(Icons.person),
                      ),
                      readOnly: true, // Make the full name read-only
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: tEmail,
                        prefixIcon: Icon(Icons.email),
                      ),
                      readOnly: true, // Make the email read-only
                    ),
                    TextFormField(
                      controller: phoneNoController,
                      decoration: const InputDecoration(
                        labelText: tPhoneNo,
                        prefixIcon: Icon(Icons.phone),
                      ),
                      readOnly: true, // Make the phone number read-only
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () => Get.to(() => const UpdateProfileScreen()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tSecondaryColor,
                          foregroundColor: tWhiteColor,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text("Edit Profile"),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 10),
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
            ],
          ),
        ),
      ),
    );
  }
}


