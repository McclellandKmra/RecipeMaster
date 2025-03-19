import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import '../../../home/screens/home_screen.dart';
import '../../screens/register/register_screen.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Function to login the user using firebase auth
  void handleLogin(BuildContext context, TextEditingController emailController, TextEditingController passwordController) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    //Verifies that the email and password fields are at least not empty
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, "Please provide both an email and a password to login");
      return;
    }

    //Uses EmailValidator to check email formatting
    if (!EmailValidator.validate(email)) {
       _showSnackBar(context, "Please provide a valid email address");
       return;
    }
    
    //Attempts to login the user with the given email and password
    try{
      final auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(email: email, password: password);
    }
    //Catch cases based on various possible errors
    on FirebaseAuthException catch (e) {
      //Non-matching email or password
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        if (!context.mounted) return;
        _showSnackBar(context, "Either the email or password is incorrect");
        return;
      }
      //Email is not in correct format
      else if (e.code == 'invalid-email') {
        if (!context.mounted) return;
        _showSnackBar(context, "Please provide a valid email address");
        return;
      }
      //Email is registered, but not available?
      else if (e.code == "user-disabled") {
        if (!context.mounted) return;
        _showSnackBar(context, "The provided email is not available");
        return;
      }
      //Too many login attempts in too short of a period
      else if (e.code == "too-many-requests") {
        if (!context.mounted) return;
        _showSnackBar(context, "You have attemped to login too many times too quickly.");
        return;
      }
      //Base error case
      else {
        if (!context.mounted) return;
        _showSnackBar(context, "FirebaseAuthException: ${e.message}");
        return;
      }
    }
    catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, "An unexpected error has occured");
      return;
    }

    if (!context.mounted) return;
    //Navigates the user to home on a successful login
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const HomeScreen())
    ); 
    return;
  }

  //Navigates the user to the register page when pressing the sign up button
  void handleRegisterButton(BuildContext context) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const RegisterScreen())
      );
    return;
  }

  //For error messages
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}