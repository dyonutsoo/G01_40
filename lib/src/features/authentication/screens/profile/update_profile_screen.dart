import 'package:door_security_lock_app/src/constants/colors.dart';
import 'package:door_security_lock_app/src/constants/sizes.dart';
import 'package:door_security_lock_app/src/constants/text.dart';
import 'package:door_security_lock_app/src/features/authentication/controllers/profile_controller.dart';
import 'package:door_security_lock_app/src/features/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../../constants/images.dart';
import '../../controllers/user_profile_services.dart';

class UpdateProfileScreen extends StatefulWidget {
  final File? imageFile; // Receive the image file

  const UpdateProfileScreen({Key? key, this.imageFile}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final controller = Get.put(ProfileController());
  UserModel? user;
  final email = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      await controller.getUserData();
      user = controller.user.value;
      if (user != null) {
        email.text = user!.email;
        fullName.text = user!.fullName;
        phoneNo.text = user!.phoneNo;
      }
    } catch (e) {
      // Handle error
    }
  }

  void _uploadImage(File? imageFile) {
    if (imageFile != null) {
      // Save the user's profile image
      UserProfileService.saveProfileImage("user_id_here", imageFile);
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
          tEditProfile,
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
              // -- IMAGE
              Hero(
                tag: 'profile_image',
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: widget.imageFile != null
                        ? Image.file(
                      widget.imageFile!, // Display the received image file
                      fit: BoxFit.cover,
                    )
                        : const Image(
                      image: AssetImage(tProfileImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: fullName,
                      decoration: const InputDecoration(
                        labelText: tFullName,
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      controller: email,
                      decoration: const InputDecoration(
                        labelText: tEmail,
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      controller: phoneNo,
                      decoration: const InputDecoration(
                        labelText: tPhoneNo,
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),

                    const SizedBox(height: tFormHeight),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (user != null) {
                            final userData = UserModel(
                              email: email.text.trim(),
                              fullName: fullName.text.trim(),
                              phoneNo: phoneNo.text.trim(),
                            );

                            await controller.updateUserData(userData);
                          }
                          _uploadImage(widget.imageFile); // Save the uploaded image
                          Get.back(); // Go back to the previous screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tSecondaryColor,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(tEditProfile,
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: tFormHeight),
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
