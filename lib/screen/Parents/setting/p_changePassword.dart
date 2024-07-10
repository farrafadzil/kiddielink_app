import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kiddielink_app/screen/Parents/p_navbar.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;

  const ChangePasswordScreen({required this.email});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (_newPasswordController.text == _confirmPasswordController.text) {
      // Update the password in Firestore
      // Find the parent document again and update the password field
      QuerySnapshot studentsSnapshot = await FirebaseFirestore.instance.collection('student').get();

      for (QueryDocumentSnapshot student in studentsSnapshot.docs) {
        QuerySnapshot parentsSnapshot = await student.reference.collection('parents').where('email', isEqualTo: widget.email).get();
        if (parentsSnapshot.docs.isNotEmpty) {
          DocumentSnapshot parentDoc = parentsSnapshot.docs.first;
          await parentDoc.reference.update({
            'password': _newPasswordController.text // Storing the new password in a new field
          });
          _showSuccessSnackBar('Password changed successfully.');
          Navigator.pop(context);
          return;
        }
      }

      _showErrorSnackBar('Failed to change the password.');
    } else {
      _showErrorSnackBar('Passwords do not match.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        title: Text(
          'Setting',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:  [
                Color(0xFFE040FB),
                Color(0xFF7C4DFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
