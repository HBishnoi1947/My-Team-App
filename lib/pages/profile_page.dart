import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String username,email;
  const ProfilePage({super.key, required this.username, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 181, 83, 76),
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 140),
        child: Column(
          children: [
            const Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey,
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name", style: TextStyle(fontSize: 17),),
                Text(widget.username, style: const TextStyle(fontSize: 17))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email", style: TextStyle(fontSize: 17),),
                Text(widget.email, style: const TextStyle(fontSize: 17))
              ],
            ),
          ]
        ),
      ),
    );
  }
}