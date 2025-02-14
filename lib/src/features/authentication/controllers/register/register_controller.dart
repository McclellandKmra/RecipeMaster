import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../screens/login/login_screen.dart';

class RegisterController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailConfirmController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  void handleRegister(BuildContext context, TextEditingController emailController, TextEditingController emailConfirmController, TextEditingController passwordController, TextEditingController passwordConfirmController) {
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
      _showSnackBar(context, "Passwords must be at least 8 characters");
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
    
    //TODO
    //Implement Firebase user auth

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