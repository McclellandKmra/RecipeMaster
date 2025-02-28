import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailConfirmController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  //Function to register the user with firebase auth
  void handleRegister(BuildContext context, TextEditingController emailController, TextEditingController emailConfirmController, TextEditingController passwordController, TextEditingController passwordConfirmController) async {
    String email = emailController.text.trim();
    String emailConfirmation = emailConfirmController.text.trim();
    String password = passwordController.text.trim();
    String passwordConfirmation = passwordConfirmController.text.trim();

    //Verifies the email and password fields are not empty
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, "Please provide both an email and a password to login");
      return;
    }

    //Uses EmailValidator to ensure proper email syntax
    if (!EmailValidator.validate(email)) {
       _showSnackBar(context, "Please provide a valid email address");
       return;
    }

    //Checks for valid password length. May check for complexity later
    if (password.length < 8) {
      _showSnackBar(context, "Provided password is too weak");
       return;
    }

    //Checks that the email and email confirmation fields are the same
    if (email != emailConfirmation) {
      _showSnackBar(context, "Provided email does not match");
      return;
    }

    //Checks that the password and password confirmation fields are the same
    if (password != passwordConfirmation) {
      _showSnackBar(context, "Provided password does not match");
      return;
    }

    //Attempts to register the user
    try{
      final auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    }
    //Catch cases for various errors
    on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        if (!context.mounted) return;
        _showSnackBar(context, "This email has already been registered");
        return;
      }
      else if (e.code == 'invalid-email') {
        if (!context.mounted) return;
        _showSnackBar(context, "Please provide a valid email address");
        return;
      }
      else if (e.code == "weak-password") {
        if (!context.mounted) return;
        _showSnackBar(context, "Provided password is too weak");
        return;
      }
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
    //Navigates the user to the login screen upon successful account creation
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const LoginScreen())
      );
    
    return;
  }

  //Navigates the user back to the login screen on button press
  void handleLoginButton(BuildContext context) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const LoginScreen())
      );
    
    return;
  }

  //Displays error messages
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}