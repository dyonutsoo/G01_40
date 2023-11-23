import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../constants/colors.dart';

class UserEditPage extends StatefulWidget {
  const UserEditPage({Key? key}) : super(key: key);

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final DatabaseReference usersRfidRef =
  FirebaseDatabase.instance.reference().child('users-rfid');

  List<Map<dynamic, dynamic>> allUsersRFIDData = [];
  List<Map<dynamic, dynamic>> filteredUsers = [];

  TextEditingController emailController = TextEditingController();
  TextEditingController keypadPassController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  int editingIndex = -1;
  String searchEmail = '';
  String searchKeypadPass = '';
  bool isSearching = false;
  String errorMessage = '';
  String saveMessage = '';

  @override
  void initState() {
    super.initState();
    loadAllUsersRFIDData();
  }

  Future<void> loadAllUsersRFIDData() async {
    usersRfidRef.onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      final Map<dynamic, dynamic>? data =
      snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        // Convert the data to a list of user data
        final List<Map<dynamic, dynamic>> usersList = [];
        data.forEach((key, value) {
          usersList.add({
            'key': key,
            ...value,
          });
        });

        setState(() {
          allUsersRFIDData = usersList;
        });
      }
    });
  }

  void editUserData(int index) {
    final userData = filteredUsers[index];
    emailController.text = userData['email'];
    keypadPassController.text = userData['keypadPass'];
    nameController.text = userData['name'];
    phoneController.text = userData['phone'];

    setState(() {
      editingIndex = index;
    });
  }

  void saveUserData() {
    if (editingIndex != -1) {
      final userKey = filteredUsers[editingIndex]['key'];
      final updatedUserData = {
        'email': emailController.text,
        'keypadPass': keypadPassController.text,
        'name': nameController.text,
        'phone': phoneController.text,
      };

      usersRfidRef.child(userKey).update(updatedUserData);

      // Clear the text controllers and reset editingIndex
      emailController.clear();
      keypadPassController.clear();
      nameController.clear();
      phoneController.clear();

      setState(() {
        editingIndex = -1;
        saveMessage = 'Saved successfully';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(saveMessage),
        ),
      );
    }
  }

  void filterUsers() {
    setState(() {
      isSearching = true;
      filteredUsers = allUsersRFIDData
          .where((user) {
        final email = user['email'] ?? '';
        final keypadPass = user['keypadPass'] ?? '';
        return email.toLowerCase() == searchEmail.toLowerCase() &&
            keypadPass == searchKeypadPass;
      })
          .toList();
    });

    if (filteredUsers.isEmpty) {
      setState(() {
        errorMessage = 'Login credentials are wrong. Try Again';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } else {
      setState(() {
        errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "User RFID Details",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (query) {
                    setState(() {
                      searchEmail = query;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter Email',
                    prefixIcon: Icon(Icons.email), // Email icon
                  ),
                ),

                TextField(
                  onChanged: (query) {
                    setState(() {
                      searchKeypadPass = query;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter Keypad Pass',
                    prefixIcon: Icon(Icons.vpn_key), // Keypad pass icon
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    filterUsers();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tSecondaryColor,
                    foregroundColor: tWhiteColor,
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: isSearching
                ? ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final userData = filteredUsers[index];

                return Container(
                  margin: const EdgeInsets.all(4.5),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: emailController,
                        readOnly: index != editingIndex,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email), // Email icon
                        ),
                      ),

                      TextFormField(
                        controller: keypadPassController,
                        readOnly: index != editingIndex,
                        decoration: const InputDecoration(
                          labelText: 'Keypad Pass',
                          prefixIcon: Icon(Icons.vpn_key), // Keypad pass icon
                        ),
                      ),

                      TextFormField(
                        controller: nameController,
                        readOnly: index != editingIndex,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person), // Name icon
                        ),
                      ),

                      TextFormField(
                        controller: phoneController,
                        readOnly: index != editingIndex,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone), // Phone icon
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (index == editingIndex)
                        ElevatedButton.icon(
                          onPressed: saveUserData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tSecondaryColor,
                            foregroundColor: tWhiteColor,
                            shape: const StadiumBorder(),
                          ),
                          icon: const Icon(Icons.save),
                          label: const Text('Save'),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: () {
                            editUserData(index);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tSecondaryColor,
                            foregroundColor: tWhiteColor,
                            shape: const StadiumBorder(),
                          ),
                          icon: const Icon(Icons.search),
                          label: const Text('Display'),
                        ),
                    ],
                  ),
                );
              },
            )
                : const Center(
              child: Text(
                'Login with your email and keypad pass.',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
