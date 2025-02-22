import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipemaster/src/features/home/screens/recipe_book.dart';
import '../../../utils/widgets/navigation_drawer.dart' as custom;
import '../../../features/home/controllers/recipe_book_controller.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String recipeName;
  const RecipeDetailsScreen({super.key, required this.recipeName});

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {

  String? recipeId;

  Future<void> _getRecipeId() async{
    User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Error fetching user');
      }
      String userId = user.uid;
      recipeId = await RecipeBookController().getRecipeId(widget.recipeName, userId);
      if (recipeId == null) {
        _showSnackBar(context, "Error fetching recipe");
      }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    _getRecipeId();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            widget.recipeName,
            style: TextStyle(
              fontFamily: "JustAnotherHand",
              fontSize: 50,
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
            child: Image.asset( //Background Image
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

}