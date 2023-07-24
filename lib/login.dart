import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learn_the_basic/firstpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'user_model.dart';
import 'user_provider.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginPageState();
}

UserType parseUserType(String value) {
  return UserType.values.firstWhere((e) => e.toString() == 'UserType.$value');
  
}

ArmyRank parseArmyRank(String value) {
  return ArmyRank.values.firstWhere((e) => e.toString() == 'ArmyRank.$value');
  
}


class _LoginPageState extends State<Login> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  bool isLoggedIn = false;
  final _auth = FirebaseAuth.instance;

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
          title: Text("EMU CADET LOGIN"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),


        body: 


         Center(
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
                child: const Text('EMU LOGIN',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: const Text('User Login/Logout',
                    style: TextStyle(fontSize: 16)),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: controllerEmail,
                enabled: !isLoggedIn,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: 'Username'),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: controllerPassword,
                enabled: !isLoggedIn,
                obscureText: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: 'Password'),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 50,
                child: TextButton(
                  child: const Text('Login'),
                  onPressed: isLoggedIn ? null : () => doUserLogin(),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 50,
                child: TextButton(
                  child: const Text('Logout'),
                  onPressed: !isLoggedIn ? null : () => doUserLogout(),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  void showSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
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
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void doUserLogin() async {
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: controllerEmail.text.trim(),
        password: controllerPassword.text.trim(),
      );

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      String uid = userCredential.user!.uid;
      String username = userData['username'];
      String email = userData['email'] ??
          'Not available'; // Assign a default value if the email is not available
      UserType userType = parseUserType(userData['userType']);
      ArmyRank armyRank = parseArmyRank(userData['armyRank']);

      UserModel currentUser = UserModel(
    uid: uid,
    username: username,
    email: email,
    userType: userType,
    armyRank: armyRank,
  );

  // Set user data in the provider
  Provider.of<UserProvider>(context, listen: false).setUser(currentUser);

  showSuccess("User was successfully logged in!");
  setState(() {
    isLoggedIn = true;
  });

  // Add the navigation to the FirstPage
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FirstPage(user: currentUser,),
      ),
    );
  });







         
    } on FirebaseAuthException catch (e) {
      showError("An error occurred while logging in.");
    } catch (e) {
      print(e);
      showError("An error occurred while logging in.");
    }
  }

  void doUserLogout() async {
    await _auth.signOut();
    setState(() {
      isLoggedIn = false;
    });
  }
}

