import 'package:flutter/material.dart';

class MyChildrenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(
            'KiddieLink',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE040FB),
                  Color(0xFF7C4DFF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/child_avatar.png'), // Replace with the actual image path
              ),
              title: Text('Alex Smith'),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle check-in/out action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color
                padding: EdgeInsets.symmetric(vertical: 15), // Button height
              ),
              child: Text(
                'Check in/out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
