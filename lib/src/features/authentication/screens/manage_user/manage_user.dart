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

  Future<void> _deleteUser(String? userId) async {
    if (userId != null) {
      final userRepository = UserRepository.instance;
      await userRepository.deleteUser(userId);
      _fetchUserList();
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
                _deleteUser(user.id); // User confirmed deletion
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerUser(String email, String password) async {
    final auth = FirebaseAuth.instance;

    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Optionally, add the user to Firestore or perform other actions.

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User registered successfully')),
      );

      _fetchUserList(); // Refresh the user list.

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
    showDialog(
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
                Navigator.of(context).pop(); // Cancel editing user
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
                // Update the user's data in Firestore
                final updatedUser = UserModel(
                  id: user.id,
                  email: emailController.text,
                  fullName: fullNameController.text,
                  phoneNo: user.phoneNo,
                );
                await userRepository.updateUserRecord(updatedUser);

                // Close the dialog after user data is updated
                Navigator.of(context).pop();

                // Refresh the user list
                _fetchUserList();
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
        title: const Text('Manage Users'),
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
                          _showDeleteConfirmationDialog(
                              user); // Show confirmation dialog
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
