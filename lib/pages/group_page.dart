import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:my_team/pages/chat_page.dart";

import "../service/databases_service.dart";
import "../widgets/widgets.dart";
import "group_info.dart";

class GroupPage extends StatefulWidget {
  final String groupName, userName, groupId;
  const GroupPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  });

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  String admin = "";
  TextEditingController messageController = TextEditingController();
  Stream? inPlayers, outPlayers;
  bool? coming;
  @override
  void initState() {
    getChatAdmin();
    super.initState();
  }

  getChatAdmin() async {
    // DatabaseService(uid: "").checkComingOrNot(
    //   widget.groupId,
    //   <String,String>{
    //   "memberId": FirebaseAuth.instance.currentUser!.uid,
    //   "userName": widget.userName}
    //   ).then((value){
    //   setState(() {
    //     print("harsh (comig): ${value}");
    //     coming=value;
    //   });
    // });
    DatabaseService(uid: "").getGroupMembers(widget.groupId).then((value){
      setState(() {
        inPlayers=value;
      });
    });
    DatabaseService(uid: "").getGroupMembers(widget.groupId).then((value){
      setState(() {
        inPlayers=value;
      });
    });
    DatabaseService(uid: '').getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: myColor,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                  context,
                  ChatPage(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      userName: widget.userName));
            },
            icon: const Icon(Icons.chat),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              nextScreen(
                  context,
                  GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: admin,
                      userName: widget.userName));
            },
            icon: const Icon(Icons.info),
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // const Expanded(flex: 1,child: SizedBox()),
            const SizedBox(height: 20,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height*.7,
                          child: Card(
                            
                            color: Colors.white54,
                            child: todayPlaying(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height*.7,
                          child: Card(
                            color: Colors.white54,
                            child: todaynotPlaying(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // const Expanded(flex: 1,child: SizedBox()),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * .3,
                    height: MediaQuery.sizeOf(context).height * .06,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                (coming == true) ? myColor : Colors.grey),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () {
                          DatabaseService().setToIn(
                              widget.groupId, <String, String>{
                            "memberId": FirebaseAuth.instance.currentUser!.uid,
                            "userName": widget.userName
                          });
                          setState(() {
                            coming = true;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "IN",
                            style: TextStyle(fontSize: 20),
                          ),
                        ))),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * .3,
                    height: MediaQuery.sizeOf(context).height * .06,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                (coming == false) ? myColor : Colors.grey),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () {
                          if (coming == false) {
                            return;
                          }
                          DatabaseService().setToOut(
                              widget.groupId, <String, String>{
                            "memberId": FirebaseAuth.instance.currentUser!.uid,
                            "userName": widget.userName
                          });
                          setState(() {
                            coming = false;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "OUT",
                            style: TextStyle(fontSize: 20),
                          ),
                        ))),
              ],
            )
          ],
        ),
      ),
    );
  }


  todayPlaying(){
    return StreamBuilder(
      stream: inPlayers,
      builder: (context,  snapshot){
        if(snapshot.hasData && snapshot.data["todayPlaying"]!=null && snapshot.data["todayPlaying"].length!=0){
            // print("Harsh : ${snapshot.data["todayPlaying"].length}");
            return ListView.builder(
              itemCount: snapshot.data['todayPlaying'].length,
              shrinkWrap: true,
              itemBuilder: (context, index){
                return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 13,
                        backgroundColor: myColor,
                        child: Text(
                          (index+1).toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(snapshot.data['todayPlaying'][index]['userName'], style: TextStyle(fontSize: 18)),
                      // subtitle: Text(snapshot.data['todayPlaying'][index]['memberId']),
                    ),
                  );
              },
            );
          }
          else{
            return const Center(child: Text("No Players"),);
        }
      },
    );
  }
  todaynotPlaying(){
    return StreamBuilder(
      stream: outPlayers,
      builder: (context,  snapshot){
        if(snapshot.hasData && snapshot.data["todayNotPlaying"]!=null && snapshot.data["todayNotPlaying"].length!=0){
            // print("Harsh : ${snapshot.data["todayNotPlaying"].length}");
            return ListView.builder(
              itemCount: snapshot.data['todayNotPlaying'].length,
              shrinkWrap: true,
              itemBuilder: (context, index){
                return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 13,
                        backgroundColor: myColor,
                        child: Text(
                          (index+1).toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(snapshot.data['todayNotPlaying'][index]['userName'], style: TextStyle(fontSize: 18)),
                      // subtitle: Text(snapshot.data['todayNotPlaying'][index]['memberId']),
                    ),
                  );
              },
            );
          }
          else{
            return const Center(child: Text("No Players"));
        }
      },
    );
  }
}
