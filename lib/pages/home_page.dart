import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_team/helper/helper_function.dart';
import 'package:my_team/pages/login_page.dart';
import 'package:my_team/pages/profile_page.dart';
import 'package:my_team/pages/search_page.dart';
import 'package:my_team/service/databases_service.dart';
import 'package:my_team/widgets/group_tile.dart';
import 'package:my_team/widgets/widgets.dart';

import '../service/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "", email = "";
  AuthService authService = AuthService();
  Stream? groups;
  String groupName="";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async{
    await HelperFunction.getUserNameKey().then((value) {if(value!=null)userName=value;});
    await HelperFunction.getUserEmailKey().then((value) {if(value!=null)email=value;});
    setState(() {});
  
    // getting the list of snapshot in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot){
      setState(() {
        groups=snapshot;

      });
    });
  }
  
  



  @override
  Widget build(BuildContext context) {
    // print("harsh : $username");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
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
        backgroundColor: myColor,
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
              userName,
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
                nextScreen(context, ProfilePage(username: userName, email: email));
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
                          icon: const Icon(Icons.done),
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => popUpDialog(context),
        elevation: 0,
        backgroundColor: myColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder:(context, setState) => 
          AlertDialog(
            title: const Text(
              "Create a group",textAlign: TextAlign.left,
            ),
            content:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (_isLoading)? 
            const Center(child: CircularProgressIndicator(color: myColor))
            :
                TextField(
                  onChanged: (val){
                    groupName = val;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: myColor,),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: myColor,),
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                )
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColor
                ), 
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: ()async{
                  if(_isLoading==false)
                  {if(groupName!=""){
                    setState(() {
                      _isLoading = true;
                    });
                    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(
                      userName, FirebaseAuth.instance.currentUser!.uid, groupName
                      ).whenComplete(() {
                        setState(() {
                          _isLoading=false;
                        });
                      });
                    Navigator.pop(context);
                    mySnackbar(context, Colors.green, "Group Created Successfully");
                  }
                  else{
        
                  }}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColor
                ), 
                child: const Text("Create"),
              ),
            ],
          )
        );
      }
    );
  }

  groupList(){
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data['groups']!=null && snapshot.data['groups'].length!=0){
            return ListView.builder(
              itemCount: snapshot.data['groups'].length,
              itemBuilder: (context,index){
                // print("harsh : ${snapshot.data['groups']}");
                return GroupTile(
                  userName: userName, 
                  groupId: snapshot.data['groups'][index]["groupId"], 
                  groupName: snapshot.data['groups'][index]["groupName"]
                  );
              },
            );
          }
          else{
            return noGroupWidget();
          }
        }
        else{
          return const Center(child: CircularProgressIndicator(color: Colors.grey,),);
        }
      },
    );
  }

   noGroupWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.now_widgets_rounded, color: Colors.grey,size: 75,),
          SizedBox(height: 10,),
          SizedBox(width: double.infinity,child: Text("You have not noined any group, tap on add icon to join now", textAlign: TextAlign.center,))
        ],
      ),
    );
   }
}