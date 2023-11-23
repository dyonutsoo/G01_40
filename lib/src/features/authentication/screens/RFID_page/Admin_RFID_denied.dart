import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RFIDDeniedPage extends StatefulWidget {
  const RFIDDeniedPage({Key? key}) : super(key: key);

  @override
  _RFIDDeniedPageState createState() => _RFIDDeniedPageState();
}

class _RFIDDeniedPageState extends State<RFIDDeniedPage> {
  final DatabaseReference accessLogsRef =
  FirebaseDatabase.instance.reference().child('access-logs-keypad');

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
        title: const Text("Password Access Denied Logs",
          style: TextStyle(
            fontSize: 18,
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
          final password = log['password'];

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
              subtitle: Text('Timestamp: $timestamp\nPassword: $password'),
            ),
          );
        },
      ),
    );
  }
}