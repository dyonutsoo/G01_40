import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RFIDGrantedPage extends StatefulWidget {
  const RFIDGrantedPage({Key? key}) : super(key: key);

  @override
  _RFIDGrantedPageState createState() => _RFIDGrantedPageState();
}

class _RFIDGrantedPageState extends State<RFIDGrantedPage> {
  final DatabaseReference accessLogsKeypadRef =
  FirebaseDatabase.instance.reference().child('access-logs-keypad');

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

        // Filter the logs to only show "Access Granted" logs
        final accessGrantedLogs =
        logList.where((log) => log['access'] == 'Access Granted').toList();

        setState(() {
          accessLogsKeypad = accessGrantedLogs;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Password Access Granted Logs",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: accessLogsKeypad.length,
        itemBuilder: (context, index) {
          final log = accessLogsKeypad[index];
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