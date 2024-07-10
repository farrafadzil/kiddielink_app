import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiddielink_app/screen/Parents/Heart%20Rate/heart_rate_graph.dart';
import 'package:kiddielink_app/screen/Parents/p_homepage.dart';
import 'package:kiddielink_app/screen/Parents/setting/p_setting.dart';
import 'package:kiddielink_app/screen/Welcome/onboarding_screen.dart';

class PNavBar extends StatelessWidget {
  final String email;
  final Map<String, dynamic> parentData;
  final String studentId;

  const PNavBar({Key? key, required this.email, required this.parentData, required this.studentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Text(
                  parentData['name'] ?? 'No name available',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0,)
              ],
            ),
            accountEmail: Text(
              email,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: parentData['photoUrl'] != null
                    ? Image.network(
                  parentData['photoUrl'],
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/avatar.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE040FB),
                  Color(0xFF7C4DFF),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PHomePage(email: email, parentData: parentData, studentId: studentId,)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingScreen(email: email, parentData: parentData, studentId: studentId,)),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                print('User logged out successfully');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              } catch (e) {
                print('Error occurred while signing out: $e');
              }
            },
          ),
        ],
      ),
    );
  }
}
