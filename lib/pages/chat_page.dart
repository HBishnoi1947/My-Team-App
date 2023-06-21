import 'package:cloud_firestore/cloud_firestore.dart';
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
  Stream<QuerySnapshot>? chats;
  String admin= "";
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    getChatAdmin();
    super.initState();
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
            onPressed: (){nextScreen(context, GroupInfo(
              groupId: widget.groupId, groupName: widget.groupName, adminName: admin, userName: widget.userName
            ));}, 
            icon: const Icon(Icons.info),
            color: Colors.white,
          )
        ],
      ),
      body: Stack(
        children: [
          chatMessage(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.sizeOf(context).width,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Send a message...",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none
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
    );
  }
  
  chatMessage(){
    // print("harsh => chat");
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData?
        ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return MessageTile(
              message: snapshot.data!.docs[index]['message'], 
              sender: snapshot.data!.docs[index]['sender'], 
              sentByMe: snapshot.data!.docs[index]['sender']==widget.userName
              );
          },
        ):
        Container(
          child: Text("sdfsdff"),
        );
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

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}