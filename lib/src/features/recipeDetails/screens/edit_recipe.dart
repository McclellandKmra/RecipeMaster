import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../home/controllers/recipe_book_controller.dart';
import 'package:path/path.dart';
import 'dart:io';


class EditRecipeScreen extends StatefulWidget{
  final VoidCallback onClose;
  const EditRecipeScreen({super.key, required this.onClose});

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final RecipeBookController _recipeController = RecipeBookController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  List<TextEditingController> ingredientNames = [];
  List<TextEditingController> ingredientAmounts = [];
  List<Map<String, String>> ingredients = [];
  List<TextEditingController> steps = [];
  List<String> tags = [];
  String? _selectedTag;

  final ImagePicker picker = ImagePicker();
  XFile? image;
  File? _imageFile;
  String? _imageUrl;


  _getRecipe() {
    //Get current user's ID
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Error fetching user');
    }
    String userID = user.uid;

    //String recipeId? = await _recipeController.getRecipeId();
  }

  

  @override
  Widget build(BuildContext context) {
    _getRecipe();

    return Material(
      /*color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.8,  // 80% of screen width
        height: MediaQuery.of(context).size.height * 0.9, // 70% of screen height
        child: SingleChildScrollView(
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
              IconButton(
                onPressed: (){}, 
                iconSize: 30,
                icon: Icon(Icons.image_outlined)
              ),
              Text("Upload an image for your recipe"),
              if (_imageFile != null) ...[
                SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _imageFile!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  )
                ),
              ],
              SizedBox(height: 15),
              TextField(
                spellCheckConfiguration: SpellCheckConfiguration(),
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Recipe Name',
                  filled: true,
                  fillColor: Color.fromARGB(255, 83, 114, 99),
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(127, 255, 255, 255),
                  ),
                ),
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              SizedBox(height: 15),
              DropdownButton<String>( //Tag Selection
                value: _selectedTag,
                hint: Text("Select a Tag"),
                items: (availableTags)
                  .where((tag) => !tags.contains(tag))
                  .map((tag) => DropdownMenuItem(value: tag, child: Text(tag)))
                  .toList(),
                onChanged: (tag) {
                  if (tag != null) _addTag(tag);
                },
              ),
              Wrap(
                spacing: 8.0,
                children: tags.map((tag) => Chip(label: Text(tag),deleteIcon: Icon(Icons.close),onDeleted: () => _removeTag(tag),backgroundColor: Colors.green[200])).toList(),   
              ),
              SizedBox(height: 15),
              Container (
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
                  ],
                ),
                child: ListView.builder(
                shrinkWrap: true,
                itemCount: ingredientNames.length,
                itemBuilder: (context, index) {
                  return IngredientInput(nameController: ingredientNames[index], amountController: ingredientAmounts[index], onRemove: () => _removeIngredient(index));
                },
              ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addIngredient,
                child: Text("Add Ingredient"),
              ),
              SizedBox(height: 15),
              Container (
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
                  ],
                ),
                child: ListView.builder(
                shrinkWrap: true,
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  return StepInput(stepController: steps[index], onRemove: () => _removeStep(index));
                },
              ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addStep,
                child: Text("Add Step"),
              ),
              ElevatedButton(
                onPressed: () => _createRecipe(context), 
                style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF157145)),
                        foregroundColor: WidgetStateProperty.all<Color>(Color(0xFFFFFFFF)),
                ),
                child: Text("Create Recipe"),
              ),
            ],
          ),
        ),
      ),
      */
    );
  }
}
