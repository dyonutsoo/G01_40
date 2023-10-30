import 'package:door_security_lock_app/src/features/authentication/screens/RFID_page/RFID_history.dart';
import 'package:flutter/material.dart';
import 'package:door_security_lock_app/src/features/authentication/screens/RFID_page/RFID_password.dart';

import '../../../../constants/colors.dart';

class RFIDPage extends StatelessWidget {
  const RFIDPage({Key? key}) : super(key: key);

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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'RFID Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildRFIDDetailItem(
              Icons.email, 'Email', 'lailasuhaila403@gmail.com'),
          _buildRFIDDetailItem(Icons.vpn_key, 'Keypad Password', '4367'),
          _buildRFIDDetailItem(Icons.person, 'Name', 'Suhaila'),
          _buildRFIDDetailItem(Icons.phone, 'Phone', '0124976046'),
          const SizedBox(height: 30), // Add spacing between details and buttons
          _buildButton("Change Password", () {
            // Navigate to the RFIDPasswordPage when "Change Password" is clicked
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RFIDPasswordPage()),
            );
          }),
          const SizedBox(height: 16),
          _buildButton("View History", () {
            // Navigate to the RFIDHistory page when "View History" is clicked
            // Make sure you have RFIDHistory defined and imported
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RFIDHistory()),
            );
          }),
        ],
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
      width: double.infinity,
      height: 50,
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
