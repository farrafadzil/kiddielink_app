import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiddielink_app/screen/Parents/add_child.dart';
import 'package:kiddielink_app/screen/Parents/p_navbar.dart';

class PHomePage extends StatefulWidget {
  final String email; // Added email parameter
  final Map<String, dynamic> parentData;
  final String studentId;

  const PHomePage({Key? key, required this.email, required this.parentData, required this.studentId}) : super(key: key);
  @override
  State<PHomePage> createState() => _PHomePageState();
}

class _PHomePageState extends State<PHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _configureFirebaseListeners();
  }

  void _requestPermissions() {
    _firebaseMessaging.requestPermission();
  }

  void _configureFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });
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
              'KiddieLink',
            style: GoogleFonts.oswald(
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/logo_kiddielink-removebg.png', // Ensure the logo image exists at this path
                  height: 200, // Adjust the height as needed
                  width: 200, // Adjust the width as needed
                ),
              ),
              Center(
                child: Text(
                  'Welcome',
                  style: GoogleFonts.lora(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7C4DFF),
                  ),
                ),
              ),

              SizedBox(height: 10),
              Center(
                child: Text(
                  'Please add a child to continue.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddChildScreen(email: widget.email, parentData: widget.parentData, studentId: widget.studentId,)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(250, 50), // Adjust the width and height as needed
                    backgroundColor: Color(0xff1de9b6),
                  ),
                  child: SizedBox(
                    width: 250,
                    child: Center(
                      child: Text(
                        'Add child',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
