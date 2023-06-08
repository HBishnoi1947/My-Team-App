import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String uid;
  DatabaseService({required this.uid});

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
      "admin": <String,String>{"groupId": uid, "userName": username},
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": ""
    });

    // update the members
    await groupDocumentReference.update({
      // "members": FieldValue.arrayUnion(["${uid}_$groupName"]),
      "members": FieldValue.arrayUnion([<String,String>{"groupId": uid, "userName": username},]),
      // "members": FieldValue.arrayUnion([uid]),
      "groupId": groupDocumentReference.id
    });

    await userCollection.doc(uid).update({
      // "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
      "groups": FieldValue.arrayUnion([<String,String>{"groupId": groupDocumentReference.id, "groupName": groupName},]),
    });
  }
}