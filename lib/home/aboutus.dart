import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage(BuildContext context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Charcha App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Developed by:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Raushan Kumar',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Charcha is a simple and intuitive chat app developed by Raushan Kumar. It allows users to communicate in real-time, share messages, and engage in conversations.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Center(
              child: Text("Bas Itna Aur Kya Chahiye 🤨",
                  style: TextStyle(fontSize: 30.0,
                  fontWeight: FontWeight.bold
                  ),
                  ),
            )
            // Add more information as needed
          ],
        ),
      ),
    );
  }
}
