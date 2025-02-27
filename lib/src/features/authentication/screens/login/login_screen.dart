import 'package:flutter/material.dart';
import '../../controllers/login/login_controller.dart';

class LoginScreen extends StatefulWidget {
   const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  //Run on initialization of the screen
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  //Deletes old resources on end
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
            child: Image.asset(
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Content (Logo and TextFields)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 0),
                   //Logo Image
                  Image.asset(
                    'assets/images/Logo.png',
                    height: 250,
                  ),

                  SizedBox(height: 60),

                  //Email Field
                  TextField( 
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

                  const SizedBox(height: 20),

                   //Password Field
                  TextField(
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

                  const SizedBox(height: 50),

                  //Login Button
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _controller.handleLogin(context, emailController, passwordController), 
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF157145)),
                        foregroundColor: WidgetStateProperty.all<Color>(Color(0xFFFFFFFF)),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: 'JustAnotherHand',
                          fontSize: 30
                        ),
                      ),
                      ),
                    ),

                  SizedBox(height: 20),

                  //Register Button
                  TextButton( 
                    onPressed: () => _controller.handleRegisterButton(context),
                    child: const Text.rich(
                      TextSpan(
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                        text: "Don't have an account?",
                        children: [
                          TextSpan(
                            text: " Sign Up!",
                            style: TextStyle(color: Color.fromARGB(255, 4, 226, 255))
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}