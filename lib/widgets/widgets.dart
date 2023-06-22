import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
  filled: true,
  // fillColor: Colors.white.withOpacity(0.5),
  fillColor: Colors.black87,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2)
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2)
  ),
);

final elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.brown.shade300,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30)
  )
);

void nextScreen(context, page){
  Navigator.push(context,MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page){
  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => page));
}

void mySnackbar(context, color, message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message,style: const TextStyle(fontSize: 14)),
    backgroundColor: color,
    duration: const Duration(seconds: 3),
  ));
}

final myColor = Color.fromARGB(135, 243, 103, 101);
final myGradient1 = Color.fromARGB(255, 209, 232, 252);
final myGradient2 = Color.fromARGB(255, 255, 232, 248);
final  myGradient3 = Color.fromARGB(193, 174, 152, 164);
final myAppbarColor = Colors.grey.withOpacity(.4);

final myBoxDecoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            myGradient1, myGradient2,myGradient3
          ]
          )
      );

void del(){
  Map student = {'name':'Tom','age': 23};  
}