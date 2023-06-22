import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_team/pages/group_info.dart';
import 'package:my_team/service/databases_service.dart';
import 'package:my_team/widgets/message_tile.dart';
import 'package:my_team/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String groupName, userName, groupId;
  const ChatPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.userName,
    });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ScrollController sc = ScrollController();
  Stream<QuerySnapshot>? chats;
  String admin= "";
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    getChatAdmin();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    sc.dispose();
    super.dispose();
  }

  

  getChatAdmin() async{
    DatabaseService(uid: "").getChats(widget.groupId).then((val){
      setState(() {
        chats=val;
      });
    });
    DatabaseService(uid: '').getGroupAdmin(widget.groupId).then((val){
      setState(() {
        admin=val;
      });
    });
  }


  scrollToBottom(int stopTime) async{
    await Future.delayed(Duration(milliseconds: stopTime));
    if(sc.hasClients) {
      try {
      sc.animateTo(sc.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      }
      catch (e){}
      }
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
          title: Text("${widget.groupName} Chat"),
          backgroundColor: myAppbarColor,
          // actions: [
          //   IconButton(
          //     onPressed: (){nextScreen(context, GroupInfo(
          //       groupId: widget.groupId, groupName: widget.groupName, adminName: admin, userName: widget.userName
          //     ));}, 
          //     icon: const Icon(Icons.info),
          //     color: Colors.white,
          //   )
          // ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: Container(child: chatMessage(),)),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.sizeOf(context).width,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onTap: () =>scrollToBottom(500),
                        controller: messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: myColor,
                          hintText: "Send a message...",
                          hintStyle: const TextStyle(color: Colors.white, fontSize: 16),
                          focusedBorder: UnderlineInputBorder(borderRadius:BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent,width: 0)),
                          border: UnderlineInputBorder(borderRadius:BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent,width: 0)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12,),
                    GestureDetector(
                      onTap: (){sendMessage();},
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: myColor,
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: const Center(child: Icon(Icons.send,color: Colors.white,)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ]
          ),
      ),
    );
  }
  
  chatMessage(){
    // print("harsh => chat");
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData?
        ListView.builder(
          controller: sc,
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          dragStartBehavior: DragStartBehavior.start,
          itemBuilder: (context, index) {
            return MessageTile(
              message: snapshot.data!.docs[index]['message'], 
              sender: snapshot.data!.docs[index]['sender'], 
              sentByMe: snapshot.data!.docs[index]['sender']==widget.userName
              );
          },
        ):
        Container();
      }
      );
  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> chatMessageMap = {
        "message" : messageController.text,
        "sender" : widget.userName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap).then((val) {
        scrollToBottom(300);
      });
      setState(() {
        messageController.clear();
      });
    }
  }
}