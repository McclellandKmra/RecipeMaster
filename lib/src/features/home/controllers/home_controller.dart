import 'package:flutter/material.dart';
import '../../authentication/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController {
  //Logs the user out
  Future<void> handleSignout (BuildContext context) async{
    //Logs out from firebase
    await FirebaseAuth.instance.signOut();

    //Routes back to login screen
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const LoginScreen())
      );
    return;
  }
}