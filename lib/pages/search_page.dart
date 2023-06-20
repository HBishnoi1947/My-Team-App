import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_team/helper/helper_function.dart';
import 'package:my_team/service/databases_service.dart';
import 'package:my_team/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? serachSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  // bool isJoined = false;

  Map<String, bool> joinedAndJoinNow = {};

  @override
  void initState() {
    super.initState();
    getCurrentUserIdAndName();
  }

  getCurrentUserIdAndName() async {
    await HelperFunction.getUserNameKey().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: myColor,
        title: const Text(
          "Search",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: myColor,
              border: Border.all(
                width: 0,
                color: myColor,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: textController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search groups....",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16)),
                )),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? Expanded(
                  child: const Center(
                  child: CircularProgressIndicator(
                    color: myColor,
                  ),
                ))
              : groupList()
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    setState(() {
      isLoading = true;
    });
    DatabaseService().searchByName(textController.text).then((snapshot) {
      setState(() {
        serachSnapshot = snapshot;
        isLoading = false;
        hasUserSearched = true;
      });
    });
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: serachSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                  userName,
                  serachSnapshot!.docs[index]["groupId"],
                  serachSnapshot!.docs[index]["groupName"],
                  serachSnapshot!.docs[index]["admin"]["userName"]);
            },
          )
        : const Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Search Groups",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ],
          );
  }

  joinedOrNot(
      String userName, String groupId, String groupName, String admin) async {
    if (joinedAndJoinNow.containsKey(groupId)) {
      return;
    }
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        joinedAndJoinNow[groupId] = value;
      });
      return value;
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    // function to check wether user exist in the group
    joinedOrNot(userName, groupId, groupName, admin);
    // print("harsh : "+groupId);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: myColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text("Admin: $admin"),
      trailing: InkWell(
          onTap: () {},
          child: (joinedAndJoinNow[groupId] == true)
              ? GestureDetector(
                  onTap: () async{
                    await DatabaseService(uid: user!.uid)
                        .toggleGroupJoin(groupId, userName, groupName);
                        setState(() {joinedAndJoinNow.remove(groupId);});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black45,
                        border: Border.all(color: Colors.white, width: 1)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Text(
                      "Joined",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () async{
                    await DatabaseService(uid: user!.uid)
                        .toggleGroupJoin(groupId, userName, groupName);
                        setState(() {joinedAndJoinNow.remove(groupId);});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: myColor,
                        border: Border.all(color: Colors.white, width: 1)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Text(
                      "Join Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
    );
  }
}
