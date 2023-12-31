import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import 'RFID_details.dart';
import 'RFID_password_access.dart';
import 'RFID_tag_access.dart';

class RFIDPage extends StatefulWidget {
  const RFIDPage({Key? key}) : super(key: key);

  @override
  _RFIDPageState createState() => _RFIDPageState();
}

class _RFIDPageState extends State<RFIDPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Manage RFID',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'RFID Details',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            _buildButton("View RFID Details", () {
              // Navigate to the RFIDPasswordPage when "Change Password" is clicked
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserEditPage()),
              );
            }),
            const SizedBox(height: 30),
            const Text(
              'RFID Access Logs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildButton("View Access History", () {
              // Navigate to the RFIDPasswordPage when "Change Password" is clicked
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RFIDPasswordAccessLogs()),
              );
            }),
            const SizedBox(height: 25),
            const Text(
              'Password Access Logs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildButton("View Access History", () {
              // Navigate to the RFIDHistory page when "View History" is clicked
              // Make sure you have RFIDHistory defined and imported
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RFIDTagAccessLogs()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRFIDDetailItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(value),
    );
  }

  Widget _buildButton(String text, void Function() onPressed) {
    return SizedBox(
      width: 300,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: tSecondaryColor,
          foregroundColor: tWhiteColor,
          side: BorderSide.none,
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}
