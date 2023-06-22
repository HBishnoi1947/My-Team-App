import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:my_team/helper/helper_function.dart";
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
    getData();
    super.initState();
  }

  getData() async{
    
    bool? boolComingOrNot = await HelperFunction.getComingOrNot(widget.groupId);
    print("harsh : getData ${boolComingOrNot}");
    if(boolComingOrNot!=null){
      setState(() {
        coming=boolComingOrNot;
      });
    }
    else{
      comingOrNot();
    }
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


  comingOrNot(){
    print("harsh : function comingornot");
    {DatabaseService(uid: "").checkComingOrNot(
      widget.groupId,
      <String,String>{
      "memberId": FirebaseAuth.instance.currentUser!.uid,
      "userName": widget.userName}
      ).then((value){
      setState(() {
        coming=value;
      });
    });}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: myBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(widget.groupName),
          backgroundColor: myAppbarColor.withOpacity(.8),
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
                              
                              color: Colors.white54.withOpacity(.1),
                              child: todayPlaying("todayPlaying"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height*.7,
                            child: Card(
                              color: Colors.white54.withOpacity(.2),
                              child: todayPlaying("todayNotPlaying"),
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
      ),
    );
  }


  todayPlaying(String players){
    return StreamBuilder(
      stream: inPlayers,
      builder: (context,  snapshot){
        if(snapshot.hasData && snapshot.data[players]!=null && snapshot.data[players].length!=0){
            // print("Harsh : ${snapshot.data["todayPlaying"].length}");
            return ListView.builder(
              itemCount: snapshot.data[players].length,
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
                      title: Text(snapshot.data[players][index]['userName'], style: const TextStyle(fontSize: 18)),
                      // subtitle: Text(snapshot.data[players][index]['memberId']),
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
  // todaynotPlaying(){
  //   return StreamBuilder(
  //     stream: outPlayers,
  //     builder: (context,  snapshot){
  //       if(snapshot.hasData && snapshot.data["todayNotPlaying"]!=null && snapshot.data["todayNotPlaying"].length!=0){
  //           print("Harsh : ${snapshot.data["todayNotPlaying"].length}");
  //           return ListView.builder(
  //             itemCount: snapshot.data['todayNotPlaying'].length,
  //             shrinkWrap: true,
  //             itemBuilder: (context, index){
  //               return Container(
  //                   padding:
  //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //                   child: ListTile(
  //                     leading: CircleAvatar(
  //                       radius: 13,
  //                       backgroundColor: myColor,
  //                       child: Text(
  //                         (index+1).toString(),
  //                         style: const TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 13,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ),
  //                     title: Text(snapshot.data['todayNotPlaying'][index]['userName'], style: const TextStyle(fontSize: 18)),
  //                     // subtitle: Text(snapshot.data['todayNotPlaying'][index]['memberId']),
  //                   ),
  //                 );
  //             },
  //           );
  //         }
  //         else{
  //           return const Center(child: Text("No Players"));
  //       }
  //     },
  //   );
  // }
}
