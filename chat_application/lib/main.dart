import 'package:chat_application/helper/helper_function.dart';
import 'package:chat_application/pages/auth/login_page.dart';
import 'package:chat_application/pages/home_page.dart';
import 'package:chat_application/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp (
  options: FirebaseOptions(apiKey:Constants.apiKey, appId: Constants.appId, messagingSenderId: Constants.messageingSenderId, projectId: Constants.projectId)
  );
  }
  else{
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);}
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn= false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }
  getUserLoggedInStatus() async{
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if(value!=null) {
        setState(() {
          _isSignedIn = value;
        });


          }
    }
    );

  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ?  const HomePage(): const LoginPage(),
    );
  }
}
