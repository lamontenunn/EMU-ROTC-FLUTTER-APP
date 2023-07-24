import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'user_model.dart';
import 'user_provider.dart';
import 'firstpage.dart';

class SignUpDetailsPage extends StatefulWidget {
  final String username;
  final String email;
  final String password;

  SignUpDetailsPage(
      {required this.username, required this.email, required this.password});

  @override
  State<SignUpDetailsPage> createState() => _SignUpDetailsPageState();
}

class _SignUpDetailsPageState extends State<SignUpDetailsPage> {
  String selectedUserType = 'MS1';
  String selectedArmyRank = 'Private';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 33, 94, 35),
          title: Text("Sign Up Details"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButton<String>(
                  value: selectedUserType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUserType = newValue!;
                    });
                  },
                  items: <String>[
                    'MS1',
                    'MS2',
                    'MS3',
                    'MS4',
                    'MSCadre',
                    'Guest'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: selectedArmyRank,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedArmyRank = newValue!;
                    });
                  },
                  items: <String>[
                    'Private',
                    'Private_First_Class',
                    'Specialist',
                    'Corporal',
                    'Sergeant',
                    'Staff_Sergeant',
                    'Sergeant_First_Class',
                    'Master_Sergeant',
                    'First_Sergeant',
                    'Sergeant_Major',
                    'Command_Sergeant_Major',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.replaceAll(
                          '_', ' ')), // Display the value with spaces
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 450,
                ),
                MaterialButton(
                  onPressed: () => doUserRegistration(),
                  color: Color.fromARGB(255, 33, 94, 35),
                  minWidth: double.infinity,
                  height: 60,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.black),
                  ),
                  child: Text("Create an Account",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Failed to create an account"),
          content: Text(errorMessage),
          actions: <Widget>[
            new ElevatedButton(
              child: const Text("Try Again"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: const Text("User was successfully created!"),
          actions: <Widget>[
            new ElevatedButton(
              child: const Text("Continue"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void doUserRegistration() async {
    final username = widget.username;
    final email = widget.email;
    final password = widget.password;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': username,
        'email': email,
        'userType': selectedUserType,
        'armyRank': selectedArmyRank,
      });

      // Create the UserModel instance
      UserModel currentUser = UserModel(
        uid: userCredential.user!.uid,
        username: username,
        email: email,
        userType: parseUserType(selectedUserType),
        armyRank: parseArmyRank(selectedArmyRank),
        profilePictureUrl: 'images/eagle-battalion-crest.jpg',
      );

      // Set user data in the provider
      Provider.of<UserProvider>(context, listen: false).setUser(currentUser);

      showSuccess();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FirstPage(
                  user: currentUser,
                )),
      );
    } on FirebaseAuthException catch (e) {
      showError("An error occurred while creating an account.");
    }
  }
}
