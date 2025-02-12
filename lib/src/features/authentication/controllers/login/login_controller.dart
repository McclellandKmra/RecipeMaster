import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../../home/home_screen.dart';
import '../../screens/register/register_screen.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin(BuildContext context, TextEditingController emailController, TextEditingController passwordController) {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, "Please provide both an email and a password to login");
      return;
    }

    if (!EmailValidator.validate(email)) {
       _showSnackBar(context, "Please provide a valid email address");
       return;
    }
    
    //TODO
    //Implement Firebase user auth

    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const HomeScreen()) //Route to the home screen upon successful login
      );
    
    return;
  }

  void handleRegisterButton(BuildContext context) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const RegisterScreen()) //Route to the home screen upon successful login
      );
    
    return;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}