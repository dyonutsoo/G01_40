import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../repository/user_repository/user_repository.dart';
import '../../../models/user_model.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({Key? key}) : super(key: key);

  @override
  _ManageUserScreenState createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  List<UserModel> userList = [];

  @override
  void initState() {
    super.initState();
    _fetchUserList();
    loadUserData();
  }

  Future<void> _fetchUserList() async {
    final userRepository = UserRepository.instance;
    final users = await userRepository.getAllUsers();
    if (users != null) {
      setState(() {
        userList = users;
      });
    }
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final currentUserEmail = user.email;

      final DatabaseReference usersRef =
      FirebaseDatabase.instance.reference().child('Users');

      usersRef.onValue.listen((event) {
        final snapshot = event.snapshot;
        final Map<dynamic, dynamic>? data =
        snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          final List<UserModel> loadedUsers = data.entries
              .map((entry) => UserModel.fromMap(entry.key, entry.value))
              .toList();

          setState(() {
            userList = loadedUsers;
          });
        }
      });
    }
  }

  Future<void> _showDeleteConfirmationDialog(UserModel user) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // User chose not to delete
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(user.id, user.email);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(String? userId, String email) async {
    if (userId != null) {
      final userRepository = UserRepository.instance;
      await userRepository.deleteUser(userId);

      final usersRef = FirebaseDatabase.instance.reference().child('Users');

      // Replace dots with underscores in email to use as a key
      final emailKey = email.replaceAll('.', '_');

      await usersRef.child(emailKey).remove();
      // Remove the user data from the database
      usersRef.child(emailKey).remove().then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error deleting user')),
        );
        print("Error deleting user: $error");
      });
    }
  }



  Future<void> _registerUser(String email, String password) async {
    final auth = FirebaseAuth.instance;

    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User registered successfully')),
      );

      loadUserData(); // Refresh the user list.

      // Clear the text fields
      _emailController.clear();
      _passwordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error registering user')),
      );
      print("Error registering user: $e");
    }
  }

  Future<void> _showAddUserDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: 'Enter Email',
                  hintText: 'Enter user\'s email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.fingerprint),
                  labelText: 'Enter Password',
                  hintText: 'Enter user\'s password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel adding user
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black, // Change text color to black
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _registerUser(_emailController.text, _passwordController.text);
                Navigator.of(context)
                    .pop(); // Close the dialog after user registration
              },
              child: const Text(
                'Add User',
                style: TextStyle(
                  color: Colors.black, // Change text color to black
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editUser(UserModel user) async {
    final userRepository = UserRepository.instance;

    // Create text editing controllers for full name and email
    final fullNameController = TextEditingController(text: user.fullName);
    final emailController = TextEditingController(text: user.email);

    // Show the edit user dialog
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                ),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel the edit
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black, // Change text color to black
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final updatedFullName = fullNameController.text ?? '';
                final updatedEmail = emailController.text ?? '';

                // Check if the updated email and full name are not empty before updating the user
                if (updatedEmail.isNotEmpty && updatedFullName.isNotEmpty) {
                  // Create a new UserModel with updated data
                  final updatedUser = UserModel(
                    id: user.id,
                    email: updatedEmail,
                    fullName: updatedFullName,
                    phoneNo: user.phoneNo,
                    profileImageUrl: user.profileImageUrl,
                  );

                  // Update the user record in the Firebase Realtime Database
                  final usersRef =
                  FirebaseDatabase.instance.reference().child('Users');

                  // Replace dots with underscores in email to use as a key
                  final emailKey = updatedEmail.replaceAll('.', '_');

                  // Update the user data under the corresponding key
                  usersRef.child(emailKey).set(updatedUser.toMap());

                  Navigator.of(context).pop(); // Close the dialog after saving

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User updated successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email and full name cannot be empty')),
                  );
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.black, // Change text color to black
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Manage Users',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'List of Users',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user.fullName),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Edit',
                        style: TextStyle(fontSize: 12),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editUser(user); // Show edit user dialog
                        },
                      ),
                      const Text(
                        'Delete',
                        style: TextStyle(fontSize: 12),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(user);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                side: BorderSide.none,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                _showAddUserDialog();
              },
              child: const Text('Add User'),
            ),
          ),
        ],
      ),
    );
  }
}
