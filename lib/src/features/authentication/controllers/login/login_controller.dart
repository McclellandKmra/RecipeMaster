import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../../home/screens/home_screen.dart';
import '../../screens/register/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin(BuildContext context, TextEditingController emailController, TextEditingController passwordController) async {
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
    
    try{
      final auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        _showSnackBar(context, "Either the email or password is incorrect");
        return;
      }
      else if (e.code == 'invalid-email') {
        _showSnackBar(context, "Please provide a valid email address");
        return;
      }
      else if (e.code == "user-disabled") {
        _showSnackBar(context, "The provided email is not available");
        return;
      }
      else if (e.code == "too-many-requests") {
        _showSnackBar(context, "You have attemped to login too many times too quickly.");
        return;
      }
      else {
        _showSnackBar(context, "FirebaseAuthException: ${e.message}");
        return;
      }
    }
    catch (e) {
      _showSnackBar(context, "An unexpected error has occured");
      return;
    }

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