import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:kiddielink_app/firebase_auth/firebase_auth_services.dart';
import 'package:kiddielink_app/screen/Parents/p_homepage.dart';
import 'package:kiddielink_app/screen/Parents/setting/p_changePassword.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  static const kDefaultPadding = 20.0;
  bool _isPasswordVisible = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Function to toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title!),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body!)],
                ),
              ),
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> saveDeviceToken(String studentId, String parentId) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    if (token != null) {
      await FirebaseFirestore.instance
          .collection('student')
          .doc(studentId)
          .collection('parents')
          .doc(parentId)
          .update({
        'deviceToken': token,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF9C27B0), // Purple 500
                      Color(0xFF7B1FA2), // Purple 700
                    ]),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 60.0, left: 22),
                    child: Column(
                      children: [
                        Image.asset('assets/logo_kiddielink-removebg.png', height: 150.0, width: 150.0,),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Hi ',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: 'Parents!',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sign in to Continue.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 300.0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                              fontSize: 16,
                            ),
                            contentPadding: EdgeInsets.only(top: 25.0),
                          ),
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: _togglePasswordVisibility,
                              child: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off, color: Colors.grey,),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                              fontSize: 16,
                            ),
                            contentPadding: EdgeInsets.only(top: 25.0),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text('Forgot Password?', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color(0xff281537),
                          ),),
                        ),
                        const SizedBox(height: 20,),
                        GestureDetector(
                          onTap: _signIn,
                          child: Container(
                            height: 55,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFE040FB),
                                  Color(0xFF7C4DFF),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text('Sign In', style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      // Query Firestore for the parent document based on the email
      QuerySnapshot studentsSnapshot =
      await FirebaseFirestore.instance.collection('student').get();

      DocumentSnapshot? parentDoc;
      String? studentId;  // Declare the studentId variable
      for (QueryDocumentSnapshot student in studentsSnapshot.docs) {
        QuerySnapshot parentsSnapshot = await student.reference
            .collection('parents')
            .where('email', isEqualTo: email)
            .get();
        if (parentsSnapshot.docs.isNotEmpty) {
          parentDoc = parentsSnapshot.docs.first;
          studentId = student.id; // Assign the student ID
          break;
        }
      }

      if (parentDoc == null) {
        _showErrorSnackBar('No parent found with this email.');
        return;
      }

      Map<String, dynamic> parentData = parentDoc.data() as Map<String, dynamic>;
      String storedPhoneNumber = parentData['phone_number']; // Assuming this is used as the default password
      String storedPassword = parentData['password'] ?? storedPhoneNumber; // Check the new password field or fallback to phone number
      String relationshipType = parentData['relationship_type'];

      // Check the provided password
      if (password == storedPassword) {
        bool isDefaultPassword = password == storedPhoneNumber; // Check if it's the default password

        if (relationshipType == 'Parent') {
          if (isDefaultPassword) {
            // Show alert dialog to change password
            _showPasswordChangeDialog(email, parentData, studentId!);
            await saveDeviceToken(studentId!, parentDoc.id); // Save the device token for the parent
          } else {
            // Redirect to parent dashboard with parent data
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PHomePage(email: email, parentData: parentData, studentId: studentId!),
              ),
            );
          }
        } else {
          _showErrorSnackBar('Unauthorized role.');
        }
      } else {
        _showErrorSnackBar('Incorrect password.');
      }
    } catch (e) {
      _showErrorSnackBar('Login failed. Please try again.');
    }
  }


  void _showPasswordChangeDialog(String email, Map<String, dynamic> parentData, String studentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Text('Do you want to change your password now?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PHomePage(email: email, parentData: parentData, studentId: studentId),
                ),
              );
            },
            child: Text('Later'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(email: email),
                ),
              );
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
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
}
