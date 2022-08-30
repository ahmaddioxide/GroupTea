import 'package:flutter/material.dart';
import 'package:grouptea/helper/HelperFunctions.dart';
import 'package:grouptea/screen/MainScreen.dart';
import 'package:grouptea/widgets/Colors.dart';
import 'package:grouptea/screen/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    //running initialization for web
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyA6yeRCT6IrFYnEM9mPYFoy_hKmpGPMe2A",
            appId: "1:676507613513:web:f7d512b47a686190e24298",
            messagingSenderId: "676507613513",
            projectId: "chat-tea-9f6e4"));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn = false;
  @override
  void initState() {
    getUserLoggedInStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Tea',
      theme: ThemeData(
        backgroundColor: Colors.white,
        primarySwatch: primary,
      ),
      home: isSignedIn? const MainScreen():const LoginScreen(),
    );
  }

  void getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isSignedIn = value;
        });
      } else {
        //  print("Error in getting Status of User Sign in");
      }
    });
  }
}
