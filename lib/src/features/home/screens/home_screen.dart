import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = HomeController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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

                  TextButton( //Sign Out Button (Currently only sends user back to login for testing)
                    onPressed: () => _controller.handleSignout(context),
                    child: const Text.rich(
                      TextSpan(
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                        children: [
                          TextSpan(
                            text: "Sign Out",
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