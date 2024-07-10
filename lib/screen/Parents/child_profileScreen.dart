import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ProfileScreen extends StatefulWidget {
  final String email;
  final Map<String, dynamic> parentData;
  final Map<String, dynamic> childInfo;
  final String studentId;

  const ProfileScreen({
    Key? key,
    required this.email,
    required this.parentData,
    required this.childInfo,
    required this.studentId,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _preferredNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  File? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  Future<void> _fetchStudentData() async {
    try {
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection('student')
          .doc(widget.studentId)
          .get();

      if (studentDoc.exists) {
        Map<String, dynamic> studentData = studentDoc.data() as Map<String, dynamic>;

        setState(() {
          _preferredNameController.text = studentData['preferred_name'] ?? '';
          _fullNameController.text = studentData['full_name'] ?? '';
          _addressController.text = studentData['address'] ?? '';
          _ageController.text = studentData['age']?.toString() ?? '';
          _dobController.text = studentData['dateOfBirth'] ?? '';
          _genderController.text = studentData['gender'] ?? '';
          _imageUrl = studentData['profile_picture'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching student data: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      String fileName = path.basename(_imageFile!.path);
      Reference storageReference = FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
      UploadTask uploadTask = storageReference.putFile(_imageFile!);
      await uploadTask;
      String downloadURL = await storageReference.getDownloadURL();

      setState(() {
        _imageUrl = downloadURL;
      });
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> _saveProfile() async {
    try {
      Map<String, dynamic> updatedData = {
        'profile_picture': _imageUrl,
      };

      await FirebaseFirestore.instance
          .collection('student')
          .doc(widget.studentId)
          .update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error saving profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "${widget.childInfo['full_name']}'s profile",
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageUrl != null && _imageUrl!.isNotEmpty
                          ? NetworkImage(_imageUrl!)
                          : AssetImage('assets/avatar.png') as ImageProvider,
                      backgroundColor: Colors.white,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          await _pickImage();
                          await _uploadImage();
                        },
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text("Full Name"),
              const SizedBox(height: 8),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              const Text("Preferred Name"),
              const SizedBox(height: 8),
              TextField(
                controller: _preferredNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              const Text("Age"),
              const SizedBox(height: 8),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              const Text("Birthday"),
              const SizedBox(height: 8),
              TextField(
                controller: _dobController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _dobController.text =
                      "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                    });
                  }
                },
                readOnly: true,
              ),
              const SizedBox(height: 16),
              const Text("Gender"),
              const SizedBox(height: 8),
              TextField(
                controller: _genderController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              const Text("Address"),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(280, 50), // Adjust the width and height as needed
                    backgroundColor: Color(0xff1de9b6),
                  ),
                  child: SizedBox(
                    width: 250,
                    child: Center(
                      child: Text(
                        'Save',
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
