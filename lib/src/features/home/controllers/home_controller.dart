import 'package:flutter/material.dart';
import '../../authentication/screens/login/login_screen.dart';

class HomeController {

  void handleSignout (BuildContext context) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const LoginScreen()) //Route to the home screen upon successful login
      );
    
    return;
  }
}