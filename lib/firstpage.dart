import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calendar_page.dart';
import 'group_chat_page.dart';
import 'login_or_signup_page.dart';
import 'settings_page.dart';
import 'user_model.dart';
import 'user_provider.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  late final UserModel currentUser;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FirstPage(user: currentUser,),
      ),
    );
  }
}


class FirstPage extends StatefulWidget {
  final UserModel user;

  const FirstPage({Key? key, required this.user}) : super(key: key);
  

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int currentIndex = 0;

  final _pageController = PageController();

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = context.watch<UserProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("EMU ROTC"),
        backgroundColor: Color.fromARGB(255, 33, 94, 35),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 33, 94, 35),
        onTap: (int index) {
          _pageController.jumpToPage(index);
        },
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/radio.png'),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
    CalendarPage(),
    Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return GroupChatPage(user: userProvider.currentUser);
      },
    ),
    SettingsPage(),
        ],
      ),
    );
  }
}
