import 'package:flutter/material.dart';
import '../../utils/widgets/navigation_drawer.dart' as custom;

class TagScreen extends StatefulWidget {
  const TagScreen({super.key});

  @override
  TagScreenState createState() => TagScreenState();
}

class TagScreenState extends State<TagScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            "My Tags",
            style: TextStyle(
              fontFamily: "JustAnotherHand",
              fontSize: 42,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 78, 143, 163),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/images/Logo.png',
              height: 40,
            ),
          ),
        ],
      ),
      drawer: custom.NavigationDrawer(),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}