import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailConfirmController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  void handleRegister(BuildContext context, TextEditingController emailController, TextEditingController emailConfirmController, TextEditingController passwordController, TextEditingController passwordConfirmController) async {
    String email = emailController.text.trim();
    String emailConfirmation = emailConfirmController.text.trim();
    String password = passwordController.text.trim();
    String passwordConfirmation = passwordConfirmController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, "Please provide both an email and a password to login");
      return;
    }

    if (!EmailValidator.validate(email)) {
       _showSnackBar(context, "Please provide a valid email address");
       return;
    }

    if (password.length < 8) {
      _showSnackBar(context, "Provided password is too weak");
       return;
    }

    if (email != emailConfirmation) {
      _showSnackBar(context, "Provided email does not match");
      return;
    }

    if (password != passwordConfirmation) {
      _showSnackBar(context, "Provided password does not match");
      return;
    }

    
    try{
      final auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showSnackBar(context, "This email has already been registered");
        return;
      }
      else if (e.code == 'invalid-email') {
        _showSnackBar(context, "Please provide a valid email address");
        return;
      }
      else if (e.code == "weak-password") {
        _showSnackBar(context, "Provided password is too weak");
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
      MaterialPageRoute(builder: (context) => const LoginScreen()) //Route to the login screen upon successful account creation
      );
    
    return;
  }

  void handleLoginButton(BuildContext context) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const LoginScreen()) //Route to the home screen upon successful login
      );
    
    return;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}