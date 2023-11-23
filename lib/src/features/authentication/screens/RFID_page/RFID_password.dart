import 'package:flutter/material.dart';

class RFIDPasswordPage extends StatelessWidget {
  const RFIDPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Manage Passwords',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPasswordAction(
              Icons.lock,
              'Set Password',
              'Set a new RFID password.',
            ),
            _buildPasswordAction(
              Icons.lock_open,
              'Change Password',
              'Change the RFID password.',
            ),
            _buildPasswordAction(
              Icons.history,
              'View Password History',
              'View the history of RFID password changes.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordAction(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blue,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
      ),
    );
  }
}
