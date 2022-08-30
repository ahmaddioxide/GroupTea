import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouptea/helper/HelperFunctions.dart';
import 'package:grouptea/services/Database_Service.dart';

import '../widgets/Widgets.dart';

class AuthService {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//Login Function
  static Future LoginUserWithEmailandPassword(
      String email, String password) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
          email: email.toString().trim(), password: password.toString().trim());
      final user = result.user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      // toastMessages(e.toString());
      return e.message;
    }
  }

  //SignUp Function
  static Future registerUserWithEmailandPassword(
      String Fullname, String email, String password) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email.toString().trim(), password: password.toString().trim());
      final user = result;
      if (user != null) {
        final user = result.user!;
        await DatabaseService(
          uid: user.uid,
        ).SavingUerData(Fullname, email);

        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      // toastMessages(e.toString());
      return e.message;
    }
  }

  static Future SignOut() async
  {
    try{
      await HelperFunctions.saveUserNameSF('');
      await HelperFunctions.saveUserEmailSF('');
      await HelperFunctions.saveUserLoggedInStatus(false);
      await firebaseAuth.signOut();
    }catch(e)
    {
      return null;
    }
  }
}


void toastMessages(String message) {
  Fluttertoast.showToast(msg: message.toString());
}
