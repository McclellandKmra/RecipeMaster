import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipemaster/src/features/home/screens/recipe_book.dart';
import '../../../utils/widgets/navigation_drawer.dart' as custom;
import '../../../features/home/controllers/recipe_book_controller.dart';
import '../../home/screens/home_screen.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String recipeName;
  const RecipeDetailsScreen({super.key, required this.recipeName});

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  String? recipeId;
  String? imageUrl;
  List<TextEditingController>? ingredientNames = [];
  List<TextEditingController>? ingredientAmounts = [];
  List<Map<String, dynamic>>? ingredients = [];
  List<String>? steps = [];
  List<String>? tags = [];
  bool isLoading = true;


  Future<void> _fetchRecipeData() async{
    try{
      //Get user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) { throw Exception('Error fetching user'); }
      String userId = user.uid;

      //Get Recipe ID 
      recipeId = await RecipeBookController().getRecipeId(widget.recipeName, userId);
      if (recipeId == null) {
        _showSnackBar("Error fetching recipe");
      }
      await _getRecipe(userId);
    } catch (e) { _showSnackBar("Error: ${e.toString()}"); }
  }

  Future<void> _getRecipe(String userId) async {
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
        isLoading = false;
      });
    } catch (e) { _showSnackBar("Error fetching recipe"); }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchRecipeData();
  }

  @override
  Widget build(BuildContext context) {
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
                                  style: TextStyle(
                                    
                                  )
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
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                ), 
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF157145)),
                                  foregroundColor: WidgetStateProperty.all<Color>(Color(0xFFFFFFFF)),
                                ),
                                child: Text("Return to recipe List")
                              ),
                            )
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

}