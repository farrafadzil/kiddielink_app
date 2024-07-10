import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker2/month_year_picker2.dart';

class AttendanceHistory extends StatefulWidget {
  final String studentId; // Unique identifier for the student

  const AttendanceHistory({Key? key, required this.studentId}) : super(key: key);

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);
  String studentName = "";

  String _month = DateFormat('MMMM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _fetchStudentName();
  }

  Future<void> _fetchStudentName() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> studentDoc = await FirebaseFirestore.instance
          .collection('student')
          .doc(widget.studentId)
          .get();

      if (studentDoc.exists) {
        setState(() {
          studentName = studentDoc.data()?['preferred_name'] ?? "Student";
        });
      }
    } catch (e) {
      print('Error fetching student name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        title: Text(
          'Attendance History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "$studentName's Attendance",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth / 20,
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(
                    _month,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth / 22,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () async {
                      final month = await showMonthYearPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2099),
                      );
                      if (month != null) {
                        setState(() {
                          _month = DateFormat('MMMM').format(month);
                        });
                      }
                    },
                    child: Text(
                      "Pick a Month",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: screenHeight / 1.5,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('student')
                    .doc(widget.studentId)
                    .collection('attendance')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final snap = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        // Convert Timestamp to DateTime
                        DateTime checkInTime = (snap[index]['check_in_time'] as Timestamp).toDate();

                        // Check if check_out_time is a Timestamp or null
                        DateTime? checkOutTime;
                        if (snap[index]['check_out_time'] != null &&
                            snap[index]['check_out_time'] is Timestamp) {
                          checkOutTime = (snap[index]['check_out_time'] as Timestamp).toDate();
                        }

                        // Convert the 'date' field to a DateTime
                        DateTime date = (snap[index]['date'] as Timestamp).toDate();

                        // Format DateTime to desired format
                        String formattedCheckInTime = DateFormat('HH:mm:ss').format(checkInTime);
                        String formattedCheckOutTime = checkOutTime != null
                            ? DateFormat('HH:mm:ss').format(checkOutTime)
                            : "--/--";

                        return DateFormat('MMMM').format(date) == _month
                            ? Container(
                          margin: const EdgeInsets.only(top: 12, left: 6, right: 6),
                          height: 150,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(2, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      DateFormat('EE\n  dd').format(date),
                                      style: TextStyle(
                                        fontSize: screenWidth / 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Check In",
                                      style: TextStyle(
                                        fontSize: screenWidth / 20,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      formattedCheckInTime,
                                      style: TextStyle(
                                        fontSize: screenWidth / 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Check Out",
                                      style: TextStyle(
                                        fontSize: screenWidth / 20,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      formattedCheckOutTime,
                                      style: TextStyle(
                                        fontSize: screenWidth / 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                            : const SizedBox();
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
