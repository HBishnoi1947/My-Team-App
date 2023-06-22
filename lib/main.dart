import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:my_team/helper/helper_function.dart";
import "package:my_team/pages/first_background_page.dart";
import "package:my_team/pages/home_page.dart";
import "package:my_team/pages/login_page.dart";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  bool? isSignedIn = await HelperFunction.getUserLoggedInStatus();
  runApp(MyApp(isSignedIn: isSignedIn));
}

class MyApp extends StatefulWidget {
  final bool? isSignedIn;
  const MyApp({super.key,required this.isSignedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (widget.isSignedIn==true) ? const HomePage(): const FirstBackgroundPage(),
    );
  }
}