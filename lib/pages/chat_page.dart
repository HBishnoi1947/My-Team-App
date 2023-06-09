import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_team/pages/group_info.dart';
import 'package:my_team/service/databases_service.dart';
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
        // print("harsh: $val");
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
              groupId: widget.groupId, groupName: widget.groupName, adminName: admin
            ));}, 
            icon: const Icon(Icons.info),
            color: Colors.white,
          )
        ],
      ),
    );
  }
}