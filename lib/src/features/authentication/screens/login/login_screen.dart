import 'package:flutter/material.dart';
import '../../../../constants/sizes.dart';
import 'package:email_validator/email_validator.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  bool validateEmail(String email) {
    bool isValid = EmailValidator.validate(email);
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
                ),
              ),
            ],
            ),
          ),
        ),
      );
  }
}

