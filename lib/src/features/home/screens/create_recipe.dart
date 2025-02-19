import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../../../utils/widgets/recipe_item.dart';
import '../controllers/recipe_book_controller.dart';
import 'recipe_book.dart';

class CreateRecipeScreen extends StatefulWidget {
  final VoidCallback onClose;
  const CreateRecipeScreen({super.key, required this.onClose});

  @override
  _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final RecipeBookController _recipeController = RecipeBookController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  List<TextEditingController> ingredientNames = [];
  List<TextEditingController> ingredientAmounts = [];
  List<TextEditingController> steps = [];
  List<String> tags = [];

 

  void _addIngredient() {
    setState(() {
      ingredientNames.add(TextEditingController());
      ingredientAmounts.add(TextEditingController());
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      ingredientNames[index].dispose();
      ingredientAmounts[index].dispose();
      ingredientNames.removeAt(index);
      ingredientAmounts.removeAt(index);
    });
  }

  void _addStep() {
    setState(() {
      steps.add(TextEditingController());
    });
  }

  void _removeStep(int index) {
    setState(() {
      steps[index].dispose();
      steps.removeAt(index);
    });
  }

  void _addTag(String tag) {
    
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.8,  // 80% of screen width
        height: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Create Recipe",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                IconButton(onPressed: widget.onClose, icon: Icon(Icons.close))
              ]
            ),
          ],
        ),
      ),
    );
  }
}