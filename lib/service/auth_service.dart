import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_team/helper/helper_function.dart';
import 'package:my_team/service/databases_service.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login

  Future loginUser(String email, String password) async{

    try{
      User? user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
      if(user !=null){
        return true;
      }
    } on FirebaseAuthException catch(e){
      // print(e.message);
      return e.message;
    }
  }

  // register
  Future registerUser(String fullName, String email, String password) async{

    try{
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
      if(user !=null){
        //call our database service to update the user data
        await DatabaseService(uid: user.uid).savingUserdata(fullName, email);

        return true;
      }
    } on FirebaseAuthException catch(e){
      // print(e.message);
      return e.message;
    }
  }



  // signout
  Future signoutUser() async{
    try{
      await HelperFunction.saveUserLoggedInStatus(false, "", "");
      firebaseAuth.signOut();
    }
    catch(e){
      return null;
    }
  }
}