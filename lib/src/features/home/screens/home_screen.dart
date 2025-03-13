import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../utils/widgets/navigation_drawer.dart' as custom;
import 'recipe_book.dart';
import '../models/recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Recipe> recipes = [];
  List<Recipe> filteredRecipes = [];

  Stream<List<Recipe>> recipeStream() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Error fetching user');
      }
      String userID = user.uid;

      CollectionReference userRecipesCollection = FirebaseFirestore.instance.collection('users').doc(userID).collection('recipes');
      return userRecipesCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return Recipe.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    }
    catch (e) {
      throw Exception('Error fetching recipes');
    }
  }

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
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            "Recipe Book",
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
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<List<Recipe>>(
                stream: recipeStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  
                  //Get the recipe list from firebase query snapshot
                  List<Recipe> recipes = snapshot.data ?? [];

                  //Set initial filtered recipes list, including all recipes
                  filteredRecipes = List.from(recipes);
                  
                  //Display the recipes on the home screen notebook page
                  return RecipeBookScreen(recipes: filteredRecipes);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
