import 'package:flutter/material.dart';
import 'package:g_chat/helper/authenticate.dart';
import 'package:g_chat/views/chatRoomsScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'helper/helperfunctions.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;
//can't use async in init state
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((val) {
      setState(() {
        userIsLoggedIn = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GChat: Chat up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.black54,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn != null ? userIsLoggedIn ? chatRoom() : Authenticate() : Container(
        child: Center(
          child: Authenticate(),
        ),
      ),
    );
  }
}