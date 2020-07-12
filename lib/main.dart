import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messangerforseeyou/helper/authenticate.dart';
import 'package:messangerforseeyou/helper/helperFunctions.dart';
import 'package:messangerforseeyou/view/chatRoomScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }


  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn  = (value!=null && value!=false)? true : false;
        print("Logged in status-> $value");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFE4E9FD),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: userIsLoggedIn ? ChatRoom() : Authenticate(),
    );
  }
}

