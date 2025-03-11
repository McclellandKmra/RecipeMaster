import 'package:flutter/material.dart';
import '../../utils/widgets/navigation_drawer.dart' as custom;

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            "Account",
            style: TextStyle(
              fontFamily: "JustAnotherHand",
              fontSize: 45,
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
      body: Column(
        children: [
          Expanded( // Ensures the background covers the full screen
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/Background.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  } 
}