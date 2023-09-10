import 'dart:io';

class UserProfileService {
  // Simulate a database or cloud storage for user profiles
  static final Map<String, String> _userProfileImages = {};

  // Save the user's profile image
  static void saveProfileImage(String userId, File imageFile) {
    // Here, you might want to upload the image to a cloud storage service
    // and get the image URL, but for simplicity, we'll store it in memory.
    _userProfileImages[userId] = imageFile.path;
  }

  // Get the user's profile image URL
  static String? getProfileImage(String userId) {
    return _userProfileImages[userId];
  }
}