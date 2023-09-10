import 'package:door_security_lock_app/src/constants/colors.dart';
import 'package:door_security_lock_app/src/constants/images.dart';
import 'package:door_security_lock_app/src/constants/sizes.dart';
import 'package:door_security_lock_app/src/constants/text.dart';
import 'package:door_security_lock_app/src/features/authentication/screens/profile/profile_menu.dart';
import 'package:door_security_lock_app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import '../../controllers/user_profile_services.dart';
import 'update_profile_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile; // Store the selected image file

  // Function to open the image picker
  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Save the user's profile image
      UserProfileService.saveProfileImage("user_id_here", _imageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left),
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
              /// -- IMAGE
              Stack(
                children: [
                  Hero(
                    tag: 'profile_image', // Unique tag for the Hero widget
                    child: GestureDetector(
                      onTap: _pickImage, // Open image picker on tap
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _imageFile != null
                              ? Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          )
                              : const Image(
                            image: AssetImage(
                                tProfileImage), // Display default image
                            fit: BoxFit.cover, // Ensure the default image fits the circular border
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: tSecondaryColor,
                      ),
                      child: IconButton(
                        onPressed: _pickImage, // Open image picker on click
                        icon: const Icon(
                          LineAwesomeIcons.pencil,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () =>
                      Get.to(() => UpdateProfileScreen(imageFile: _imageFile)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: tSecondaryColor,
                      foregroundColor: tWhiteColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text("View & Edit Profile"),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: "Settings",
                  icon: LineAwesomeIcons.cog,
                  onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.sign_out,
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
                          onPressed: () =>
                              AuthenticationRepository.instance.logout(),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              side: BorderSide.none),
                          child: const Text("Yes"),
                        ),
                      ),
                      cancel: OutlinedButton(
                          onPressed: () => Get.back(), child: const Text("No")),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
