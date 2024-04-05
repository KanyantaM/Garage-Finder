import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_api_firebase/user_api_firebase_auth.dart';

class ProfileImage extends StatefulWidget {
  final bool isGarage;
  const ProfileImage({Key? key, required this.isGarage}) : super(key: key);

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _uploadImageToStorage();
      } else {
        showNoImageSelectedDialog(
            context, 'No Image Selected', 'Please select an image to upload.');
      }
    });
  }

  Future<void> _uploadImageToStorage() async {
    if (_imageFile == null) return;

    UserApiFirebase userApi = UserApiFirebase();

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      
        UploadTask uploadTask =
            _storage.ref('profile_images/$fileName').putFile(_imageFile!);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        String downloadUrl = await snapshot.ref.getDownloadURL();
if (!widget.isGarage) {
       await userApi.updatePhotUrl(downloadUrl);
      } else{
         // Store the download URL in Firestore
        await _firestore.collection('garages').doc(userApi.getCurrentUser()!.id).update({
          'imageUrl': downloadUrl,
        });
      }
    } catch (e) {
      Exception('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _getImage,
          child: Container(
            width: 344,
            height: 82,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: _imageFile != null
                  ? DecorationImage(
                      image: FileImage(_imageFile!),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/344x82"),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showNoImageSelectedDialog(
    BuildContext context, String title, String content) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
