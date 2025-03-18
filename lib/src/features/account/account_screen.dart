import 'package:flutter/material.dart';
import '../../utils/widgets/navigation_drawer.dart' as custom;
import '../home/controllers/home_controller.dart';
import '../home/models/recipe.dart';
import '../home/controllers/recipe_book_controller.dart';
import '../recipeDetails/controllers/recipe_details_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  final HomeController homeController = HomeController();
  final RecipeBookController recipeBookController = RecipeBookController();
  final RecipeDetailsController recipeDetailsController = RecipeDetailsController();
  Stream<List<Recipe>> recipes = Stream.empty();
  String userId = "";

  Future<void> deleteAccount(BuildContext context) async {
    //Delete the recipes that belong to the account
    String? recipeId = "";
    getRecipes(context);
    recipes.listen((recipeList) async {
      for (int i = 0; i < recipeList.length; i++) {
        recipeId = await recipeBookController.getRecipeId(userId, recipeList[i].name, recipeList[i].createdAt);
        if (!context.mounted) return;
        recipeDetailsController.deleteRecipe(context, userId, recipeId, recipeList[i].imageUrl);
      }
    });

    //homeController.handleSignout(context);
  }

  Future<void> getRecipes(BuildContext context) async {
    CollectionReference userRecipesCollection = FirebaseFirestore.instance.collection('users').doc(userId).collection('recipes');
    recipes = userRecipesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
          return Recipe.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
    getRecipes(context);
  }

  Future<void> _init() async {
    await getUserId();
  }
  
  Future<void> getUserId() async {
    //Get user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) { 
        throw Exception('Error fetching user'); 
      }
      userId = user.uid;
  }

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
      body: Stack(
        children: [
          Positioned.fill(
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
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: 
                  () => showDialog<String>(
                    context: context,
                    builder:
                        (BuildContext context) => AlertDialog(
                          actionsOverflowAlignment: OverflowBarAlignment.center,
                          title: Text('Delete Account?'),
                          content: const Text('This action cannot be undone.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                //Navigator.pop(context, 'OK');
                                deleteAccount(context);
                              },
                              child: const Text('Delete'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 202, 52, 52)),
                foregroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)),
              ),
              child: Text("Delete Account")
            ),
          ),
        ],
      ),
    );
  } 
}