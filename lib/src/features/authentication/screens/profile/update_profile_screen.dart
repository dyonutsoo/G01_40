import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../../constants/colors.dart';
import '../../../../constants/images.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text.dart';
import '../../../models/user_model.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/user_profile_services.dart';
import '../dashboard/dashboard.dart';
import 'package:image_picker/image_picker.dart';


class UpdateProfileScreen extends StatefulWidget {
  final File? imageFile;

  const UpdateProfileScreen({Key? key, this.imageFile}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final controller = Get.put(ProfileController());
  UserModel? user;
  String? email;
  String? fullName;
  String? phoneNo;

  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneNoController = TextEditingController();
  String? profileImageUrl;
  final ImagePicker _imagePicker = ImagePicker();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    loadUserData();
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


  Future<void> updateUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final currentUserEmail = user.email;
      if (currentUserEmail != null) {
        // Replace dots with underscores in email to use as a key
        final emailKey = currentUserEmail.replaceAll('.', '_');

        // Create a reference to the "Users" node in the Realtime Database.
        final DatabaseReference usersRef =
        FirebaseDatabase.instance.reference().child('Users');

        final updateData = UserModel(
          email: emailController.text.trim(),
          fullName: fullNameController.text.trim(),
          phoneNo: phoneNoController.text.trim(),
          profileImageUrl: profileImageUrl,
        );

        await usersRef.child(emailKey).set(updateData.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.to(() => const Dashboard()),
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
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        labelText: tFullName,
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: tEmail,
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      controller: phoneNoController,
                      decoration: const InputDecoration(
                        labelText: tPhoneNo,
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: tFormHeight),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          updateUserProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tSecondaryColor,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Save Profile',
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

