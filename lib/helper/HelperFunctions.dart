import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userLoginedInKey = "USERLOGINNEDKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  static Future saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoginedInKey, isUserLoggedIn);
  }
  static Future saveUserNameSF (String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }
  static Future saveUserEmailSF (String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoginedInKey);
  }

  static Future getUserName()async
  {
    SharedPreferences sf=await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
  static Future getEmail() async
  {
    SharedPreferences sf=await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }
}
