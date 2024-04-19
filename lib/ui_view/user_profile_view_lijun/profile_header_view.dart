import 'package:flutter/material.dart';
import '../../mixy_app_theme.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'dart:typed_data';
class ProfileHeaderView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  String imageUrl;

  ProfileHeaderView({
    Key? key,
    this.animationController,
    this.animation,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _ProfileHeaderViewState createState() => _ProfileHeaderViewState();
}

class _ProfileHeaderViewState extends State<ProfileHeaderView> {
  auth.User? get user => auth.FirebaseAuth.instance.currentUser;
  String? get userId => user?.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _uploadProfilePicture() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File file = File(image.path);
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('user_Image')
          .child('$userId.jpg');
      UploadTask uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);

      final urlImageUser = await snapshot.ref.getDownloadURL();
      // Create a reference to the location you want to upload to in Firebase Storage
      /*final Reference storageReference = FirebaseStorage.instance.ref().child('profile_pictures/${Path.basename(image.path)}');

      // Upload the file to Firebase Storage
      final Uint8List data = await file.readAsBytes();  
      final UploadTask uploadTask = storageReference.putData(data);

      // Get the URL of the uploaded image
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = (await downloadUrl.ref.getDownloadURL());*/

      // Update the user's profile picture URL in Firestore
      await _firestore.collection('Users').doc(userId).update({'imageUrl': urlImageUser});

      // Update the local state
      setState(() {
        widget.imageUrl = urlImageUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.animation!,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Container(
            height: 150,
            child: Center(
              child: GestureDetector(
                onTap: _uploadProfilePicture,
                child: ClipOval(
                  child: widget.imageUrl != null && Uri.parse(widget.imageUrl).isAbsolute
                      ? Image.network(
                          widget.imageUrl,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : const FlutterLogo(size: 150),  // Placeholder image
                ),
              ),
            ),
          ),
          // Other children...
        ],
      ),
    );
  }
}