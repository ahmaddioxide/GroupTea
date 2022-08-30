import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouptea/services/AuthenticationService.dart';
import 'package:grouptea/services/Database_Service.dart';
import 'package:grouptea/shared/Shared.dart';
import 'package:grouptea/widgets/Colors.dart';
import 'package:grouptea/widgets/PrimaryText.dart';
import 'package:grouptea/widgets/SecondaryText.dart';
import 'package:grouptea/screen/SignupScreen.dart';
import 'package:lottie/lottie.dart';

import '../helper/HelperFunctions.dart';
import '../widgets/Widgets.dart';
import 'MainScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner=false;
  bool obsecurePassword = true;
  String Email = '';
  String Password = '';
  final _formKey = GlobalKey<FormState>();
  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: showSpinner?Center(child: CircularProgressIndicator(color: primary,strokeWidth: 5,),):SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 13),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/ChatTea.png',
                      height: 120,
                      width: 120,
                    ),
                    const SizedBox(
                       width: 3,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryText(
                            text: "Group",
                            fontSize: 40,
                          ),
                          Text(
                            "Tea",
                            style: TextStyle(
                              color: primary,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
              ),
              SecondaryText(
                text: "Login to see what's communities are up to",
                fontSize: 18,
              ),
              //lottie Animation Chat
              const SizedBox(
                height: 10,
              ),
               SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset('assets/lottieAnimations/chat.json'),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10,right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius:const BorderRadius.all(Radius.circular(20)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //Email Field
                      Padding(
                        padding: const EdgeInsets.only(top: 30,bottom: 10,left: 10,right: 10),
                        child: TextFormField(
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)
                                ? null
                                : "Enter a valid email";
                          },
                          onChanged: (value) {
                            setState(() {
                              Email = value;
                              // print(Email);
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: primary,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide(
                                    color: primary,
                                    width: 3,
                                  )),
                              prefixIcon:const Icon(
                                Icons.alternate_email_rounded,
                              ),
                              labelText: "Email",
                              labelStyle: TextStyle(fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              )),
                        ),
                      ),
                      //Password FormField
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, right: 10.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Password must be at least 6 characters";
                            } else {
                              null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              Password = val;
                              // print(Email);
                            });
                          },
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obsecurePassword,
                          cursorColor: primary,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(color: primary, width: 3),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(obsecurePassword
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded),
                                onPressed: () => {
                                  setState(() {
                                    obsecurePassword = !obsecurePassword;
                                  })
                                },
                              ),
                              prefixIcon:const Icon(
                                Icons.key,
                              ),
                              // icon: Icon(Icons.alternate_email_rounded),
                              labelText: "Password",
                              labelStyle:const TextStyle(fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              )),
                        ),
                      ),
                      //Text and Button Create Account
                      Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SecondaryText(
                              text: "Don't have an account?",
                              fontSize: 14,
                            ),
                            TextButton(
                                onPressed: CreateAccountPressed,
                                child: PrimaryText(
                                  text: "Create Account",
                                  fontSize: 15,
                                ))
                          ],
                        ),
                      ),
                      // Login Button
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 3,
                        child: ElevatedButton(
                            onPressed:LoginPressed,

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Icon( Icons.rocket_launch_rounded),
                                 SizedBox(
                                  width: 5,
                                ),
                                const Text("LOGIN")
                              ],
                            )),
                      ),
                      const SizedBox(height: 30,)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void LoginPressed() async {
    if(_formKey.currentState!.validate())
    {
      setState(() {
        showSpinner=true;
      });
      await AuthService.LoginUserWithEmailandPassword( Email, Password).then((value) async {
        if(value==true)
        {
          QuerySnapshot snapshot=await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(Email);
          // print("Query RUNEED");
          //Saving value to SF
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullname']);
          await HelperFunctions.saveUserEmailSF(Email);
          await HelperFunctions.saveUserLoggedInStatus(true);
          setState(() {
            showSpinner=false;
            showSnackBar(context,primary,"Logged In");
            nextScreenReplacement(context, MainScreen());
          });
        }else
        {
          showSnackBar(context,primary,value);
          setState(() {
            showSpinner=false;
          });

        }
      });
    }


  }
  void CreateAccountPressed() {
    nextScreen(context, const SignUpScreen());
  }
}
