import 'package:flutter/material.dart';
import 'src/features/authentication/screens/login/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landing Page (Login)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(200, 112, 160, 175)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen()
    );
  }
}

 

