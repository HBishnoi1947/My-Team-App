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
  @override
  void initState() {
    getChatAdmin();
    super.initState();
  }

  getChatAdmin() async {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * .3,
                    height: MediaQuery.sizeOf(context).height * .06,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.grey),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    ))),
                        onPressed: () {},
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
                          backgroundColor: MaterialStateProperty.all(Colors.grey),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    ))),
                        onPressed: () {},
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
}
