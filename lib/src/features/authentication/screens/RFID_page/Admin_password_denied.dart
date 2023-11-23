import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PasswordDeniedPage extends StatefulWidget {
  const PasswordDeniedPage({Key? key}) : super(key: key);

  @override
  _PasswordDeniedPageState createState() => _PasswordDeniedPageState();
}

class _PasswordDeniedPageState extends State<PasswordDeniedPage> {
  final DatabaseReference accessLogsRef =
  FirebaseDatabase.instance.reference().child('access-logs');

  List<Map<dynamic, dynamic>> allLogs = [];
  List<Map<dynamic, dynamic>> accessDeniedLogs = [];

  @override
  void initState() {
    super.initState();
    loadAccessLogs();
  }

  Future<void> loadAccessLogs() async {
    accessLogsRef.onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      final Map<dynamic, dynamic>? data =
      snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        // Convert the data to a list of logs
        final List<Map<dynamic, dynamic>> logList = [];
        data.forEach((key, value) {
          logList.add(value);
        });

        setState(() {
          allLogs = logList;
          accessDeniedLogs = logList
              .where((log) => log['access'] == 'Access Denied')
              .toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("RFID Access Denied Logs",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: accessDeniedLogs.length,
        itemBuilder: (context, index) {
          final log = accessDeniedLogs[index];
          final access = log['access'];
          final timestamp = log['timestamp'];
          final uid = log['uid'];
          final name = log['name'];

          return Container(
            margin: const EdgeInsets.all(4.5), // Add margin for spacing
            padding: const EdgeInsets.all(3), // Add padding for spacing
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black, // You can change the border color
                width: 1.0, // You can change the border width
              ),
            ),
            child: ListTile(
              title: Text('Status: $access'),
              subtitle: Text('Timestamp: $timestamp\nName: $name\nUID: $uid'),
            ),
          );
        },
      ),
    );
  }
}