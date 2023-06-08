import 'package:flutter/material.dart';
import 'package:my_team/helper/helper_function.dart';
import 'package:my_team/pages/login_page.dart';
import 'package:my_team/pages/profile_page.dart';
import 'package:my_team/pages/search_page.dart';
import 'package:my_team/widgets/widgets.dart';

import '../service/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "", email = "";
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async{
    await HelperFunction.getUserNameKey().then((value) {if(value!=null)username=value;});
    await HelperFunction.getUserEmailKey().then((value) {if(value!=null)email=value;});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("harsh : $username");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 181, 83, 76),
        actions: [
          IconButton(
            onPressed: (){
              nextScreen(context, const SearchPage());
            }, 
            icon: const Icon(Icons.search) 
          )
        ],
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Groups",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),

      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 181, 83, 76),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(height: 15,),
            Text(
              username,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(height: 30,),
            const Divider(height: 2,),
            ListTile(
              onTap: (){},
              selectedColor: Colors.black,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: (){
                nextScreen(context, const ProfilePage());
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () async{
                showDialog(
                  context: context, 
                  builder: (context){
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.cancel),
                        ),
                        IconButton(
                          onPressed: ()async{
                            await authService.signoutUser();
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
                          },
                          icon: const Icon(Icons.cancel),
                        ),
                      ],
                    );
                  }
                  );
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.logout),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
    // Container(child: Center(child: ElevatedButton(onPressed: ()=> authService.signoutUser(), child: Text("LogOut")),),);}
  }
}