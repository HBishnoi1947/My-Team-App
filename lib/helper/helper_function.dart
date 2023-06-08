import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  //saving the data to SF

  static saveUserLoggedInStatus(bool isUserLoggedIn,String userName,String userEmail) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    await sf.setBool(userLoggedInKey, isUserLoggedIn);
    await sf.setString(userNameKey, userName);
    await sf.setString(userEmailKey, userEmail);
  }

  // static Future<bool> saveUserNameKey(String userName) async{
  //   SharedPreferences sf = await SharedPreferences.getInstance();
  //   return await sf.setString(userNameKey, userName);
  // }

  // static Future<bool> saveUserEmailKey(String userEmail) async{
  //   SharedPreferences sf = await SharedPreferences.getInstance();
  //   return await sf.setString(userEmailKey, userEmail);
  // }

  //gettig the data from SF

  static Future<String?> getUserNameKey() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
  static Future<bool?> getUserLoggedInStatus() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
  static Future<String?> getUserEmailKey() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

}