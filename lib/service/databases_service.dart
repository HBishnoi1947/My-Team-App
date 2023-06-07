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
}