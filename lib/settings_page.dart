import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                              EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
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
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                WavyAnimatedText('Logout'),
                              ],
                              isRepeatingAnimation: true,
                              onTap: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await Future.delayed(Duration(milliseconds: 300));
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
  }
}








void signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Navigate to the login page or any other page after a successful sign out.
    Navigator.pushReplacementNamed(context, 'LoginPage()');
  } catch (e) {
    print('Error signing out: $e');
  }
}
