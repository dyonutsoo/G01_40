import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import 'Admin_RFID_denied.dart';
import 'Admin_RFID_details.dart';
import 'Admin_RFID_granted.dart';
import 'Admin_password_denied.dart';
import 'Admin_password_granted.dart';
import 'Admin_user_data.dart';

class AdminRFIDPage extends StatefulWidget {
  const AdminRFIDPage({Key? key}) : super(key: key);

  @override
  _AdminRFIDPageState createState() => _AdminRFIDPageState();
}

class _AdminRFIDPageState extends State<AdminRFIDPage> {

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
                'Users RFID',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            _buildButton("Display Users\'s RFID", () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserDataDisplay()),
              );
            }),
            const SizedBox(height: 10),
            _buildButton("Edit Users\'s RFID", () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserSearchPage()),
              );
            }),
            const SizedBox(height: 30),
            const Text(
              'RFID Tag History Logs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildButton("View Granted Access", () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PasswordGrantedPage()),
              );
            }),
            const SizedBox(height: 16),
            _buildButton("View Denied Access", () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PasswordDeniedPage()),
              );
            }),
            const SizedBox(height: 25),
            const Text(
              'Password History Logs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildButton("View Granted Access", () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RFIDGrantedPage()),
              );
            }),
            const SizedBox(height: 16),
            _buildButton("View Denied Access", () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RFIDDeniedPage()),
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
