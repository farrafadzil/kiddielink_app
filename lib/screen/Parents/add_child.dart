import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiddielink_app/screen/Parents/display_child.dart';  // Ensure you have this import to navigate to ChildInfoScreen

class AddChildScreen extends StatefulWidget {
  final String email;
  final Map<String, dynamic> parentData;
  final String studentId;

  const AddChildScreen({Key? key, required this.email, required this.parentData, required this.studentId}) : super(key: key);

  @override
  _AddChildScreenState createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _inviteCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Add a Child'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Please enter the invite code you received from your school.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter the code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an invite code';
                  }
                  return null;
                },
                onSaved: (value) {
                  _inviteCode = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _submitInviteCode();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff1de9b6),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text(
                  'Submit Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitInviteCode() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('student')
          .where('unique_code', isEqualTo: _inviteCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> childInfo = querySnapshot.docs.first.data() as Map<String, dynamic>;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invite code is valid!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChildInfoScreen(
              email: widget.email,
              parentData: widget.parentData,
              childInfo: childInfo,
              uniqueCode: _inviteCode!, // Pass the unique code to ChildInfoScreen
              studentId: widget.studentId,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid invite code. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }
}
