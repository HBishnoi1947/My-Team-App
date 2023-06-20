import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  // referemce for our collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("user");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");


  // saving the userdata
  Future savingUserdata(String fullName, String email) async{
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async{
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async{
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  Future createGroup(String username, String id, String groupName) async{
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      // "admin": "${id}_$username",
      "admin": <String,String>{"adminId": id, "userName": username},
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": ""
    });

    // update the members
    await groupDocumentReference.update({
      // "members": FieldValue.arrayUnion(["${uid}_$groupName"]),
      "members": FieldValue.arrayUnion([<String,String>{"memberId": id, "userName": username},]),
      // "members": FieldValue.arrayUnion([uid]),
      "groupId": groupDocumentReference.id
    });

    await userCollection.doc(uid).update({
      // "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
      "groups": FieldValue.arrayUnion([<String,String>{"groupId": groupDocumentReference.id, "groupName": groupName},]),
    });
  }

  getChats(String groupId) async{
    return groupCollection.doc(groupId).collection("meassages").orderBy('time').snapshots();
  }
  
  Future getGroupAdmin(String groupId) async{
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    // print("harsh (getAdmin): ${documentSnapshot.data()}");
    return documentSnapshot['admin']['userName'];
  }

  //getting the members
  getGroupMembers(groupId) async{
    return groupCollection.doc(groupId).snapshots();
  }



  // search
  searchByName(String groupName){
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // function to check wether user is in the group
  Future<bool> isUserJoined(String groupName, String groupId, String userName) async{
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    Map <String, dynamic> m = {
      "groupId" : groupId,
      "groupName" : groupName
    };
    List <dynamic> groups = await documentSnapshot['groups'];
    if(
      groups.any((element) {
        return mapEquals(element, m);
      })
      )
      {
      return true;
    }
    else{
      return false;
    }
  }


  // function to join and exit the group
  toggleGroupJoin(String groupId, String userName, String groupName) async{
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups  = await documentSnapshot['groups'];
    Map <String, dynamic> givenGroup = {
      "groupId" : groupId,
      "groupName" : groupName
    };
    Map <String, dynamic> givenUser = {
      "memberId" : uid,
      "userName" : userName
    };
    // if user has our groups -> then remove user else join user
    if (groups.any((element){return mapEquals(element, givenGroup);})) {
      print("harsh : leaving group");
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove([givenGroup])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove([givenUser])
      });
    } else {
      print("harsh : joining group");
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion([givenGroup])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion([givenUser])
      });
    }
  }
}