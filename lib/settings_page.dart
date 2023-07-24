import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'user_model.dart';
import 'user_provider.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading = false;
  String? _profilePictureUrl;

  

  @override
void initState() {
    super.initState();
    _getProfilePictureUrl();
  }




 Widget build(BuildContext context) {
  return Consumer<UserProvider>(
    builder: (context, userProvider, child) {
      if(userProvider.currentUser == null){
        return Container();  // Or any other widget to show when currentUser is null
      }
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                          userProvider.currentUser.profilePictureUrl!.isNotEmpty
                              ? NetworkImage(userProvider.currentUser.profilePictureUrl!)
                              : null,
                      child: userProvider.currentUser.profilePictureUrl!.isEmpty
                          ? Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 60,
                            )
                          : null,
                    ),
                  ),
                ),

                // Display user information
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: _pickAndUploadImage,
                          child: Text('Upload Profile Picture'),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.lightGreen),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'User Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text('Email'),
                        subtitle: Text(userProvider.currentUser.email),
                      ),
                      ListTile(
                        leading: Icon(Icons.star),
                        title: Text('Rank'),
                        subtitle: Text(userProvider.currentUser.armyRankString
                            .replaceAll('_', ' ')),
                      ),
                      ListTile(
                        leading: Icon(Icons.group),
                        title: Text('MS LEVEL'),
                        subtitle: Text(userProvider.currentUser.userTypeString),
                      ),
                    ],
                  ),
                ),
                // Logout button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _isLoading
                        ? SpinKitWave(
                            color: Colors.lightGreen,
                            size: 50.0,
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await Future.delayed(Duration(milliseconds: 300));
                              signOut(context);
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.lightGreen),
                              textStyle: MaterialStateProperty.all(
                                TextStyle(color: Colors.white),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.lightGreen,
                                    Colors.lightGreenAccent,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    WavyAnimatedText('Logout!'),
                                  ],
                                  isRepeatingAnimation: true,
                                  onTap: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await Future.delayed(
                                        Duration(milliseconds: 300));
                                    signOut(context);
                                  },
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image from the device
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      final File file = File(imageFile.path);
      final Reference ref =
          FirebaseStorage.instance.ref().child('profile_pictures').child(uid);

      // Upload the image to Firebase Storage
      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        // Get the image URL from Firebase Storage
        final String imageUrl = await snapshot.ref.getDownloadURL();

        // Update the image URL in the Firestore 'users' collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'imageUrl': imageUrl});

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile picture uploaded successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload profile picture.')));
      }
    }
  }

  Future<void> _getProfilePictureUrl() async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final profilePictureUrl = userProvider.currentUser.profilePictureUrl ?? 'images/eagle-battalion-crest.jpg';
  setState(() {
    _profilePictureUrl = profilePictureUrl;
  });
}
  }

  void signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login page or any other page after a successful sign out.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

