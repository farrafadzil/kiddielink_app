import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kiddielink_app/screen/Parents/setting/widget/edit_item.dart';

class EditAccountScreen extends StatefulWidget {
  final String email;
  final Map<String, dynamic> parentData;
  final String studentId;

  const EditAccountScreen({
    Key? key,
    required this.email,
    required this.parentData,
    required this.studentId,
  }) : super(key: key);

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  File? _image;
  String? _originalImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.parentData['name'] ?? '');
    _emailController = TextEditingController(text: widget.email);
    _originalImageUrl = widget.parentData['photoUrl'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = 'profiles/${widget.email}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask = FirebaseStorage.instance.ref(fileName).putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: $e'),
        ),
      );
      return null;
    }
  }

  Future<void> _saveChanges() async {
    try {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
      }

      DocumentReference studentRef = FirebaseFirestore.instance.collection('student').doc(widget.studentId);
      QuerySnapshot parentsSnapshot = await studentRef.collection('parents').where('email', isEqualTo: widget.email).get();

      if (parentsSnapshot.docs.isNotEmpty) {
        DocumentSnapshot parentDoc = parentsSnapshot.docs.first;
        Map<String, dynamic> updateData = {
          'name': _nameController.text,
        };

        if (imageUrl != null) {
          updateData['photoUrl'] = imageUrl;
          setState(() {
            _originalImageUrl = imageUrl;
          });
        }

        await parentDoc.reference.update(updateData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account updated successfully!'),
          ),
        );
        Navigator.pop(context); // Close the screen after successful update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No parent found with the provided email: ${widget.email}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update account: $e'),
        ),
      );
    }
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
        leadingWidth: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: _saveChanges,
              style: IconButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: Size(60, 50),
                elevation: 3,
              ),
              icon: Icon(Ionicons.checkmark, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Account",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Photo",
                widget: Column(
                  children: [
                    _image != null
                        ? Image.file(
                      _image!,
                      height: 100,
                      width: 100,
                    )
                        : (_originalImageUrl != null
                        ? Image.network(
                      _originalImageUrl!,
                      height: 100,
                      width: 100,
                    )
                        : Image.asset(
                      "assets/avatar.png",
                      height: 100,
                      width: 100,
                    )),
                    TextButton(
                      onPressed: _pickImage,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.lightBlueAccent,
                      ),
                      child: const Text("Upload Image"),
                    )
                  ],
                ),
              ),
              EditItem(
                title: "Name",
                widget: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                  ),
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Email",
                widget: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
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
