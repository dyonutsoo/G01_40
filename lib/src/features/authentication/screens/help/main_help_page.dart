import 'package:flutter/material.dart';
import 'send_enquiry.dart';

class MainHelpPage extends StatelessWidget {
  const MainHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text("Help Desk",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Contacts:',
              style: TextStyle(fontSize: 24),
            ),
            const Text(
              'Phone: +60 11-5426-2766',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Email: dee.layla12@gmail.com.com',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Background color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SendEnquiryPage()),
                );
              },
              child: const Text('Send Enquiry'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Help Desk App',
    home: MainHelpPage(),
  ));
}
