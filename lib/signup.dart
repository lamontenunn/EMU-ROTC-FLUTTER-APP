import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firstpage.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String selectedUserType = 'MS1';
  String selectedArmyRank = 'Private';

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 33, 94, 35),
          title: Text("Sign Up"),
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
                Container(
                  height: 200,
                  child: Image.asset("images/wings.png"),
                ),
                Center(
                  child: const Text("SIGN UP",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: const Text("",
                      style: TextStyle(fontSize: 15)),
                ),
                TextField(
                  controller: controllerUsername, // finish
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: "Username"),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerEmail, // finish
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: "Email Address"),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: "Password"),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                    height: 50,
                    child: TextButton(
                      child: const Text("Create an account"),
                      onPressed: () => doUserRegistration(),
                    )),
                    DropdownButton<String>(
  value: selectedUserType,
  onChanged: (String? newValue) {
    setState(() {
      selectedUserType = newValue!;
    });
  },
  items: <String>['MS1', 'MS2', 'MS3', 'MS4', 'MSCadre', 'Guest']
    .map<DropdownMenuItem<String>>((String value) {
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
  items: <String>['Private', 'Private First Class', 'Specialist', 'Corporal', 'Sergeant', 'Staff Sergeant', 'Sergeant First Class', 'Master Sergeant', 'First Sergeant', 'Sergeant Major', 'Command Sergeant Major', 'Sergeant Major of the Army']
    .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
),
              ],
            ),
          ),
        ),
      ),
    );
  }

   void showSucess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sucesss!"),
          content: const Text("User was sucessfully created!"),
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

  void doUserRegistration() async {
  final username = controllerUsername.text.trim();
  final email = controllerEmail.text.trim();
  final password = controllerPassword.text.trim();

  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'username': username,
      'email': email,
      'userType': selectedUserType,
      'armyRank': selectedArmyRank,
    });

    showSucess();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FirstPage()),
    );
  } on FirebaseAuthException catch (e) {
    showError("An error occurred while creating an account.");
  } catch (e) {
    print(e);
    showError("An error occurred while creating an account.");
  }
}
}
