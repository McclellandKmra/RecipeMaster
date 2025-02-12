import 'package:flutter/material.dart';
import '../../controllers/register/register_controller.dart';

class RegisterScreen extends StatefulWidget {
   const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController _controller = RegisterController();

  late final TextEditingController emailController;
  late final TextEditingController emailConfirmController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    emailConfirmController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();

  }

  @override
  void dispose() {
    emailController.dispose();
    emailConfirmController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset( //Background Image
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Content (Logo and TextFields)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Adjust padding as needed
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 0),
                  Image.asset( //Logo Image
                    'assets/images/Logo.png',
                    height: 250,
                  ),

                  SizedBox(height: 60),
                  
                  TextField( //Email Field
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: const Color.fromARGB(127, 255, 255, 255),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      filled: true,
                      fillColor: Color(0xFF157145),
                    ),
                    style: TextStyle(
                      fontFamily: 'JustAnotherHand',
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20), // Add spacing between fields

                  TextField( //Email Field
                    controller: emailConfirmController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Confirm Email',
                      hintStyle: TextStyle(
                        color: const Color.fromARGB(127, 255, 255, 255),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      filled: true,
                      fillColor: Color(0xFF157145),
                    ),
                    style: TextStyle(
                      fontFamily: 'JustAnotherHand',
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField( //Password Field
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: const Color.fromARGB(127, 255, 255, 255),
                      ),
                      filled: true,
                      fillColor: Color(0xFF157145),
                    ),
                    style: TextStyle(
                      fontFamily: 'JustAnotherHand',
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 20),

                  TextField( //Password Field
                    controller: passwordConfirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(
                        color: const Color.fromARGB(127, 255, 255, 255),
                      ),
                      filled: true,
                      fillColor: Color(0xFF157145),
                    ),
                    style: TextStyle(
                      fontFamily: 'JustAnotherHand',
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
 
                  Text(
                    "Password must be at least 8 characters long",
                    style: TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 30),

                  SizedBox( //Register Button
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _controller.handleRegister(context, emailController, emailConfirmController, passwordController, passwordConfirmController), 
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF157145)),
                        foregroundColor: WidgetStateProperty.all<Color>(Color(0xFFFFFFFF)),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: 'JustAnotherHand',
                          fontSize: 30
                        ),
                      ),
                      ),
                    ),

                  SizedBox(height: 10),

                  TextButton( //Register Button
                    onPressed: () => _controller.handleLoginButton(context),
                    child: const Text.rich(
                      TextSpan(
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                        text: "Have an account?",
                        children: [
                          TextSpan(
                            text: " Log In!",
                            style: TextStyle(color: Color.fromARGB(255, 4, 226, 255))
                            ),
                        ]
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}