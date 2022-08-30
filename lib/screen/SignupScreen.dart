
import 'package:flutter/material.dart';
import 'package:grouptea/helper/HelperFunctions.dart';
import 'package:grouptea/screen/LoginScreen.dart';
import 'package:grouptea/screen/MainScreen.dart';
import 'package:grouptea/services/AuthenticationService.dart';
import 'package:grouptea/shared/Shared.dart';
import 'package:grouptea/widgets/Colors.dart';
import 'package:grouptea/widgets/PrimaryText.dart';
import 'package:grouptea/widgets/SecondaryText.dart';
import 'package:grouptea/widgets/Widgets.dart';
import 'package:lottie/lottie.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showSpinner=false;
  bool _passwordVisibilty = true;
  final _formKey = GlobalKey<FormState>();
  String FullName = '';
  String Email = '';
  String Password = '';
  AuthService authService =AuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: showSpinner?Center(child: CircularProgressIndicator(color: primary,strokeWidth: 6,)):SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 13),
                child: Center(
                    child: PrimaryText(
                  text: "Signup",
                  fontSize: 40,
                )),
              ),
              SecondaryText(
                text: "Create your account to explore and chat",
                fontSize: 18,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 180,
                  width: 180,
                  child: Lottie.asset('assets/lottieAnimations/signup.json'),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                margin:const EdgeInsets.only(left: 10,right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius:const BorderRadius.all(Radius.circular(20)),
                ),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //Full Name Form
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0,left: 10,right: 10,bottom: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                FullName = value;
                              });
                            },
                            validator: (value) {
                              return RegExp('[a-zA-Z]').hasMatch(value!)
                                  ? null
                                  : "Enter a valid name";
                            },
                            keyboardType: TextInputType.name,
                            cursorColor: primary,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide:
                                      BorderSide(color: primary, width: 3),
                                ),
                                prefixIcon:const Icon(
                                  Icons.person_outline_rounded,
                                ),
                                labelText: "Full Name",
                                labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                )),
                          ),
                        ),
                        //Email Form
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                Email = value;
                              });
                            },
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: primary,
                            validator: (value) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!)
                                  ? null
                                  : "Enter a valid email";
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide:
                                      BorderSide(color: primary, width: 3),
                                ),
                                prefixIcon:const Icon(
                                  Icons.alternate_email_rounded,
                                ),
                                // icon: Icon(Icons.alternate_email_rounded),
                                labelText: "Email",
                                labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                )),
                          ),
                        ),
                        //Password Form
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                Password = value;
                              });
                            },
                            validator: (value) {
                              if (value!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else {
                                null;
                              }
                            },
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _passwordVisibilty,
                            cursorColor: primary,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide:
                                      BorderSide(color: primary, width: 3),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(_passwordVisibilty
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded),
                                  onPressed: ChangeVisibilityOfPassword,
                                ),
                                prefixIcon:const Icon(
                                  Icons.key,
                                ),
                                // icon: Icon(Icons.alternate_email_rounded),
                                labelText: "Password",
                                labelStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                )),
                          ),
                        ),
                        //Already account and sign in button
                        Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SecondaryText(
                                text: "Already have an account?",
                                fontSize: 15,
                              ),
                              TextButton(
                                  onPressed: () {
                                    nextScreenReplacement(context,const LoginScreen());
                                  },
                                  child: PrimaryText(
                                    text: "Login",
                                    fontSize: 15,
                                  ))
                            ],
                          ),
                        ),
                        //SignUp Button
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 3,
                          child: ElevatedButton(
                              onPressed: () {
                                  SignUp();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   const Icon(Icons.rocket_launch_rounded),
                                 const  SizedBox(
                                    width: 5,
                                  ),
                                 const Text("SIGNUP"),
                                ],
                              )),
                        ),
                        const  SizedBox(height: 30,),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void ChangeVisibilityOfPassword() {
    setState(() {
      _passwordVisibilty = !_passwordVisibilty;
    });
  }

  void SignUp() async{
    if(_formKey.currentState!.validate())
      {
        setState(() {
          showSpinner=true;
        });
        await AuthService.registerUserWithEmailandPassword(FullName, Email, Password).then((value) async {
        if(value==true)
        {
            showSnackBar(context,primary,"Account Crated");
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserEmailSF(Email);
            await HelperFunctions.saveUserNameSF(FullName);
            setState(() {
          showSpinner=false;
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
}
