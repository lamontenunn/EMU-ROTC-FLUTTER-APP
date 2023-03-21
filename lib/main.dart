import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_or_signup_page.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMU ROTC',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
