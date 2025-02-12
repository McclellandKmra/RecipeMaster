import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override


  Widget build(BuildContext context) {
    return Scaffold(body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset( //Background Image
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),
          Text("Home Screen")
        ],
      ),
    );
  }
}