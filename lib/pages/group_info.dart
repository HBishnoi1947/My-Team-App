import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_team/service/databases_service.dart';
import 'package:my_team/widgets/widgets.dart';

class GroupInfo extends StatefulWidget {
  final String groupName, adminName, groupId,userName;
  const GroupInfo({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.adminName,
    required this.userName,
    });

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async{
    DatabaseService(uid: "").getGroupMembers(widget.groupId).then((value){
      setState(() {
        members=value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: myColor,
        title: const Text("Group Info"),
        actions: [
          IconButton(
            onPressed: ()async{
              showDialog(
                  context: context, 
                  builder: (context){
                    return AlertDialog(
                      title: const Text("Exit"),
                      content: const Text("Are you sure you want to leave the group"),
                      actions: [
                        IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.cancel),
                        ),
                        IconButton(
                          onPressed: ()async{
                            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).toggleGroupJoin(widget.groupId, widget.userName, widget.groupName);
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          icon: const Icon(Icons.done),
                        ),
                      ],
                    );
                  }
                  );
            }, 
            icon: const Icon(Icons.exit_to_app, color: Colors.white,)
            )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: myColor.withOpacity(0.2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: myColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Admin: ${widget.adminName}")
                    ],
                  )
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }
  memberList(){
    return StreamBuilder(
      stream: members,
      builder: (context,  snapshot){
        // if(snapshot.hasData ) print("harsh: has data");
        // else  print("harsh: no data");

        if(snapshot.hasData && snapshot.data["members"]!=null && snapshot.data["members"].length!=0){
            // print("Harsh : ${snapshot.data["members"].length}");
            return ListView.builder(
              itemCount: snapshot.data['members'].length,
              shrinkWrap: true,
              itemBuilder: (context, index){
                return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: myColor,
                        child: Text(
                          snapshot.data['members'][index]['userName']
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(snapshot.data['members'][index]['userName']),
                      // subtitle: Text(snapshot.data['members'][index]['memberId']),
                    ),
                  );
              },
            );
          }
          else{
            return const Center(child: Text("No Members"),);
        }
      },
    );
  }
}