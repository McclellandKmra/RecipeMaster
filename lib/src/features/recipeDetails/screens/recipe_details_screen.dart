import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recipemaster/src/features/recipeDetails/screens/edit_recipe.dart';
import '../../../utils/widgets/navigation_drawer.dart' as custom;
import '../../../features/home/controllers/recipe_book_controller.dart';
import '../controllers/recipe_details_controller.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String recipeName;
  final DateTime? createdAt;
  const RecipeDetailsScreen({super.key, required this.recipeName, required this.createdAt});

  @override
  RecipeDetailsScreenState createState() => RecipeDetailsScreenState();
}

class RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final RecipeDetailsController recipeDetailsController = RecipeDetailsController();
  String? recipeId;
  String? imageUrl;
  List<TextEditingController>? ingredientNames = [];
  List<TextEditingController>? ingredientAmounts = [];
  List<Map<String, dynamic>>? ingredients = [];
  List<String>? steps = [];
  List<String>? tags = [];
  bool favorite = false;
  bool isLoading = true;
  bool _isEditingRecipe = false;

  String userId = "";


  Future<void> _fetchRecipeData() async{
    try{
      //Get Recipe ID 
      recipeId = await RecipeBookController().getRecipeId(userId, widget.recipeName, widget.createdAt);
      if (recipeId == null) {
        _showSnackBar("Error fetching recipe");
      }
      await _getRecipe();
    } catch (e) { _showSnackBar("Error: ${e.toString()}"); }
  }

  Future<void> _getRecipe() async {
    try {
      DocumentSnapshot recipeDoc = await FirebaseFirestore.instance.collection("users").doc(userId).collection("recipes").doc(recipeId).get();
      if (!recipeDoc.exists) {
        _showSnackBar("Recipe not found");
        return;
      }

      Map<String, dynamic> data = recipeDoc.data() as Map<String, dynamic>;

      setState(() {
        imageUrl = data['imageUrl'];
        ingredients = List<Map<String, dynamic>>.from(data['ingredients']);
        steps = List<String>.from(data['steps']);
        tags = List<String>.from(data['tags']);
        favorite = data['favorite'];
        isLoading = false;
      });
    } catch (e) { _showSnackBar("Error fetching recipe"); }
  }

  Future<void> _toggleFavorite() async {
    try {
      bool newFavoriteStatus = !favorite;
      await FirebaseFirestore.instance.collection("users").doc(userId).collection("recipes").doc(recipeId).update({'favorite': newFavoriteStatus});
      setState(() {
        favorite = newFavoriteStatus;
      });
    }
    catch (e) { _showSnackBar("Error updating favorite status"); }
  }

  Future<void> getUserId() async {
    //Get user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) { 
        throw Exception('Error fetching user'); 
      }
      userId = user.uid;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onClose() {
    setState(() {
      _isEditingRecipe = false;
    });
  }

  Future<void> _init() async {
    await getUserId();
    await _fetchRecipeData();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            "Recipe Details",
            style: TextStyle(
              fontFamily: "JustAnotherHand",
              fontSize: 45,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 78, 143, 163),
        actions: [
          IconButton(
            icon: Icon(
              favorite ? Icons.star : Icons.star_border,
              color: favorite ? Colors.yellow : null
            ),
            onPressed: _toggleFavorite,
          ),
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
      body: isLoading
    ? Center(child: CircularProgressIndicator())
    : Column( // Use Column to structure the layout properly
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
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrl != null)
                        Image.network(imageUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.contain),
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/Paper.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                widget.recipeName,
                                style : TextStyle(
                                  fontSize: 40, fontFamily: "JustAnotherHand"
                                )
                              ),
                            ),
                            Text(
                              "Tags: ${tags?.join(', ') ?? ''}",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Ingredients:",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            ...?ingredients?.map((ing) =>
                                Text(
                                  "${ing['name']}: ${ing['amount']}",
                                )
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Steps:",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            ...?steps?.map((step) => Text("- $step")),

                            SizedBox(height: 16),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditingRecipe = true;
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)),
                                  foregroundColor: WidgetStateProperty.all<Color>(Color(0xFF157145)),
                                ),
                                child: Text("Edit Recipe")
                              ),
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
                                            title: Text('Delete \n${widget.recipeName}?'),
                                            content: const Text('This action cannot be undone.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, 'OK');
                                                  recipeDetailsController.deleteRecipe(context, userId, recipeId, imageUrl);
                                                  Navigator.pop(context, 'OK');
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
                                child: Text("Delete Recipe")
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF157145)),
                                  foregroundColor: WidgetStateProperty.all<Color>(Color(0xFFFFFFFF)),
                                ),
                                child: Text("Return to Recipes")
                              ),
                            )
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isEditingRecipe) 
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5), // Semi-transparent background
                      child: Center(
                        child: EditRecipeScreen(onClose: _onClose, recipeName: widget.recipeName, createdAt: widget.createdAt), // Pass onClose function
                      ),
                    )
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

}