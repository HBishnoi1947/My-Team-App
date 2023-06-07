import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_team/service/databases_service.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login


  // register
  Future registerUser(String fullName, String email, String password) async{

    try{
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
      if(user !=null){
        //call our database service to update the user data
        await DatabaseService(uid: user.uid).updateUserdata(fullName, email);

        return true;
      }
    } on FirebaseAuthException catch(e){
      print(e.message);
      return e.message;
    }
  }



  // signout
}