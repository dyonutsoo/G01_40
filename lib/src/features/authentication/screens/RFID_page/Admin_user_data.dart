import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserDataDisplay extends StatefulWidget {
  const UserDataDisplay({Key? key}) : super(key: key);

  @override
  _UserDataDisplayState createState() => _UserDataDisplayState();
}

class _UserDataDisplayState extends State<UserDataDisplay> {
  final DatabaseReference usersRfidRef =
  FirebaseDatabase.instance.reference().child('users-rfid');

  List<Map<dynamic, dynamic>> userDataList = [];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
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
          userDataList = usersList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'All Users RFID Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: userDataList.length,
        itemBuilder: (context, index) {
          final userData = userDataList[index];
          final email = userData['email'];
          final keypadPass = userData['keypadPass'];
          final name = userData['name'];
          final phone = userData['phone'];

          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email: $email"),
                Text("Keypad Pass: $keypadPass"),
                Text("Name: $name"),
                Text("Phone: $phone"),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: UserDataDisplay(),
  ));
}
