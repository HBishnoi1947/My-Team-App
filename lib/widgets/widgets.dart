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

const myColor = Color.fromARGB(255, 181, 83, 76);