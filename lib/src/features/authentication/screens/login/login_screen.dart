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

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                  const SizedBox(height: 50),

                  SizedBox( //Login Button
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}