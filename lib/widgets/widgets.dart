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