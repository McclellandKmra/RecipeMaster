import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../utils/widgets/navigation_drawer.dart' as custom;
import '../home/controllers/home_controller.dart';
import '../home/models/recipe.dart';
import '../home/controllers/recipe_book_controller.dart';
import '../recipeDetails/controllers/recipe_details_controller.dart';
import '../authentication/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    try {
      //Delete the recipes that belong to the account
      List<Future<void>> deletionTasks = [];
      QuerySnapshot recipesSnapshot = await userDoc.collection('recipes').get();
      for (var doc in recipesSnapshot.docs) {
        if (!context.mounted) break;
        deletionTasks.add(recipeDetailsController.deleteRecipe(context, userId, doc.id, doc['imageUrl']));
      }

      //Takes a list of async functions (like the delete recipe calls) and waits for all of them to complete before continuing. 
      await Future.wait(deletionTasks);

      //Remove the user from firestore
      await userDoc.delete();

      //Remove the user from firebase authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {await user.delete();}
      else { 
        if (!context.mounted) {
          return;
        }
        _showSnackBar(context, "Error deleting user"); 
      }

      //Take the user back to the login page
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false, // Clears back stack
      );
    }
    catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, "Error deleting account");
    }
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

  //For error messages
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                                Navigator.pop(context, 'OK');
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