import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RFIDPasswordAccessLogs extends StatefulWidget {
  const RFIDPasswordAccessLogs({Key? key}) : super(key: key);

  @override
  _RFIDPasswordAccessLogsState createState() => _RFIDPasswordAccessLogsState();
}

class _RFIDPasswordAccessLogsState extends State<RFIDPasswordAccessLogs> {
  final DatabaseReference accessLogsKeypadRef =
  FirebaseDatabase.instance.reference().child('access-logs');

  List<Map<dynamic, dynamic>> accessLogsKeypad = [];

  @override
  void initState() {
    super.initState();
    loadAccessLogsKeypad();
  }

  Future<void> loadAccessLogsKeypad() async {
    accessLogsKeypadRef.onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      final Map<dynamic, dynamic>? data =
      snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        // Convert the data to a list of logs
        final List<Map<dynamic, dynamic>> logList = [];
        data.forEach((key, value) {
          logList.add(value);
        });

        final accessLogs = logList
            .where((log) =>
        log['access'] == 'Access Granted' || log['access'] == 'Access Denied')
            .toList();

        setState(() {
          accessLogsKeypad = logList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("RFID Access Logs"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: accessLogsKeypad.length,
        itemBuilder: (context, index) {
          final log = accessLogsKeypad[index];
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