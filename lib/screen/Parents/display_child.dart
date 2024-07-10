import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiddielink_app/screen/Parents/add_child.dart';
import 'package:kiddielink_app/screen/Parents/child_dashboard.dart';
import 'package:kiddielink_app/screen/Parents/p_navbar.dart';

class ChildInfoScreen extends StatefulWidget {
  final String email;
  final Map<String, dynamic> parentData;
  final Map<String, dynamic> childInfo;
  final String studentId;
  final String uniqueCode;

  const ChildInfoScreen({
    Key? key,
    required this.email,
    required this.parentData,
    required this.childInfo,
    required this.studentId, // Add the unique code parameter
    required this.uniqueCode,
  }) : super(key: key);

  @override
  State<ChildInfoScreen> createState() => _ChildInfoScreenState();
}

class _ChildInfoScreenState extends State<ChildInfoScreen> {
  String? _attendanceCode;
  Map<String, dynamic>? updatedChildInfo;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceCode();
    _fetchChildInfo();
  }

  Future<void> _fetchChildInfo() async {
    try {
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection('student')
          .doc(widget.studentId)
          .get();

      if (studentDoc.exists) {
        setState(() {
          updatedChildInfo = studentDoc.data() as Map<String, dynamic>?;
        });
      }
    } catch (e) {
      print("Error fetching child info: $e");
    }
  }


  Future<void> _fetchAttendanceCode() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('student')
          .where('unique_code', isEqualTo: widget.uniqueCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _attendanceCode = querySnapshot.docs.first['attendance_code'] ?? 'No code available';
        });
      }
    } catch (e) {
      setState(() {
        _attendanceCode = 'Error fetching code';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        drawer: PNavBar(email: widget.email, parentData: widget.parentData, studentId: widget.studentId,),
        appBar: AppBar(
          title: Text(
            'My Children',
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
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddChildScreen(
                      email: widget.email,
                      parentData: widget.parentData,
                      studentId: widget.studentId,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: updatedChildInfo != null &&
                        updatedChildInfo!.containsKey('profile_picture') &&
                        updatedChildInfo!['profile_picture'] != null &&
                        updatedChildInfo!['profile_picture'].isNotEmpty
                        ? NetworkImage(updatedChildInfo!['profile_picture'])
                        : AssetImage('assets/child_image.png') as ImageProvider,
                  ),
                  title: Text(widget.childInfo['full_name'] ?? 'No name available'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChildDashboard(
                          email: widget.email,
                          parentData: widget.parentData,
                          childInfo: widget.childInfo,
                          studentId: widget.studentId,  // Pass the unique code to ChildDashboard
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Spacer(),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'My Check In Code:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _attendanceCode ?? 'Loading...',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle check-in/out button press
                },
                child: Text(
                  'Check in/out',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3F51B5),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
