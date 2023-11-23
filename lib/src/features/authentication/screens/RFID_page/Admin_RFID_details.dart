import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../constants/colors.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({Key? key}) : super(key: key);

  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final DatabaseReference usersRfidRef =
  FirebaseDatabase.instance.reference().child('users-rfid');

  List<Map<dynamic, dynamic>> allUsersRFIDData = [];
  List<Map<dynamic, dynamic>> filteredUsers = [];

  TextEditingController emailController = TextEditingController();
  TextEditingController keypadPassController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  int editingIndex = -1;
  String searchQuery = '';
  bool isSearching = false;

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
      });
    }
  }

  void deleteUser(int index) {
    if (index != -1) {
      final userKey = filteredUsers[index]['key'];
      usersRfidRef.child(userKey).remove();

      // Clear the text controllers and reset editingIndex
      emailController.clear();
      keypadPassController.clear();
      nameController.clear();
      phoneController.clear();

      setState(() {
        editingIndex = -1;
      });
    }
  }

  void filterUsers() {
    if (searchQuery.isNotEmpty) {
      setState(() {
        isSearching = true;
        filteredUsers = allUsersRFIDData
            .where((user) {
          final email = user['email'] ?? '';
          return email.toLowerCase().contains(searchQuery.toLowerCase());
        })
            .toList();
      });
    } else {
      setState(() {
        isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "All Users RFID Data",
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
            child: TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                  filterUsers();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search by Email',
                prefixIcon: Icon(Icons.search), // Add search icon
              ),
            ),
          ),
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
                          prefixIcon: Icon(Icons.email), // Add email icon
                        ),
                      ),
                      TextFormField(
                        controller: keypadPassController,
                        readOnly: index != editingIndex,
                        decoration: const InputDecoration(
                          labelText: 'Keypad Pass',
                          prefixIcon: Icon(Icons.vpn_key), // Add keypad pass icon
                        ),
                      ),
                      TextFormField(
                        controller: nameController,
                        readOnly: index != editingIndex,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person), // Add name icon
                        ),
                      ),
                      TextFormField(
                        controller: phoneController,
                        readOnly: index != editingIndex,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone), // Add phone icon
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (index == editingIndex)
                        ElevatedButton(
                          onPressed: saveUserData,
                          child: const Text('Save'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tSecondaryColor,
                            foregroundColor: tWhiteColor,
                            shape: const StadiumBorder(),
                          ),
                        )
                      else
                        ElevatedButton(
                          onPressed: () {
                            editUserData(index);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tSecondaryColor,
                            foregroundColor: tWhiteColor,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('Search'),
                        ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          deleteUser(index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tSecondaryColor,
                          foregroundColor: tWhiteColor,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            )
                : const Center(
              child: Text('No user found. Start searching by email.'),
            ),
          ),
        ],
      ),
    );
  }
}
