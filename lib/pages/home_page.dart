import 'package:flutter/material.dart';
import 'package:my_team/helper/helper_function.dart';

import '../service/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: ElevatedButton(onPressed: ()=> authService.signoutUser(), child: Text("LogOut")),),);
  }
}