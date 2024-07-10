// ChildDashboard.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiddielink_app/screen/Parents/Heart%20Rate/heart_rate_graph.dart';
import 'package:kiddielink_app/screen/Parents/attendance_history.dart';
import 'package:kiddielink_app/screen/Parents/child_profileScreen.dart';

class ChildDashboard extends StatefulWidget {
  final String email;
  final Map<String, dynamic> parentData;
  final Map<String, dynamic> childInfo;
  final String studentId;  // Add the unique code parameter

  const ChildDashboard({
    Key? key,
    required this.email,
    required this.parentData,
    required this.childInfo,
    required this.studentId,  // Add the unique code parameter
  }) : super(key: key);

  @override
  State<ChildDashboard> createState() => _ChildDashboardState();
}

class _ChildDashboardState extends State<ChildDashboard> {
  Map<String, dynamic>? updatedChildInfo;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Ionicons.chevron_back_outline),
          ),
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildProfileSection(),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  children: [
                    _buildGridTile('Attendance', Icons.check, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceHistory(studentId: widget.studentId,),  // Pass the unique code to AttendanceHistory
                        ),
                      );
                    }),
                    _buildGridTile('Health Checks', Icons.monitor_heart, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HeartRateGraph()),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    if (updatedChildInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: updatedChildInfo!.containsKey('profile_picture') &&
                updatedChildInfo!['profile_picture'] != null &&
                updatedChildInfo!['profile_picture'].isNotEmpty
                ? NetworkImage(updatedChildInfo!['profile_picture'])
                : AssetImage('assets/child_image.png') as ImageProvider,
          ),
          SizedBox(height: 8.0),
          Text(
            updatedChildInfo!['full_name'] ?? 'No name available',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              // Navigate to the profile details page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    email: widget.email,
                    parentData: widget.parentData,
                    childInfo: updatedChildInfo!,
                    studentId: widget.studentId,
                  ),
                ),
              );
            },
            child: Text('Profile'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xff1de9b6), // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Colors.blue),
            SizedBox(height: 8.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
