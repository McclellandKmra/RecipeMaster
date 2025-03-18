import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../home/controllers/recipe_book_controller.dart';
import '../../../utils/widgets/ingredient_input.dart';
import '../../../utils/widgets/step_input.dart';
import '../../../constants/tags.dart';
import 'package:path/path.dart';
import 'dart:io';


class EditRecipeScreen extends StatefulWidget{
  final VoidCallback onClose;
  final String recipeName;
  final DateTime? createdAt;
  const EditRecipeScreen({super.key, required this.onClose, required this.recipeName, required this.createdAt});

  @override
  EditRecipeScreenState createState() => EditRecipeScreenState();
}

class EditRecipeScreenState extends State<EditRecipeScreen> {
  final RecipeBookController _recipeController = RecipeBookController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  List<TextEditingController> ingredientNames = [];
  List<TextEditingController> ingredientAmounts = [];
  List<Map<String, dynamic>> ingredients = [];
  List<TextEditingController> steps = [];
  List<String> tags = [];
  String? _selectedTag;
  bool favorite = false;

  final ImagePicker picker = ImagePicker();
  XFile? image;
  File? _imageFile;
  String? _imageUrl;
  String ? _newImageUrl;


  _getRecipe() async{
    try {
      //Get current user's ID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Error fetching user');
      }
      String userId = user.uid;
      String? recipeId = await _recipeController.getRecipeId(userId, widget.recipeName, widget.createdAt);

      DocumentSnapshot recipeDoc = await FirebaseFirestore.instance.collection("users").doc(userId).collection("recipes").doc(recipeId).get();

      if (!recipeDoc.exists) {
        return;
      }

      Map<String, dynamic> data = recipeDoc.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = data['name'] ?? '';
        tags = List<String>.from(data['tags'] ?? []);
        _imageUrl = data['imageUrl'] ?? '';

        // Populate ingredient controllers
        ingredientNames = List<TextEditingController>.from(
          (data['ingredients'] ?? []).map((ing) => TextEditingController(text: ing['name']))
        );
        ingredientAmounts = List<TextEditingController>.from(
          (data['ingredients'] ?? []).map((ing) => TextEditingController(text: ing['amount']))
        );

        // Populate step controllers
        steps = List<TextEditingController>.from(
          (data['steps'] ?? []).map((step) => TextEditingController(text: step))
        );

        favorite = data['favorite'];
      });
    } catch(e) { return; }
  }

  _editRecipe(BuildContext context) async{
    //Combine ingredient name and amount 
    _createIngredientsMap();

    //Gets new image url, and deletes old one
    _newImageUrl = await _uploadImage();

    if (_newImageUrl != null) {
      _deleteImage(_imageUrl);
      try {
        _recipeController.editRecipe(_nameController.text.trim(), _newImageUrl!, tags, ingredients, steps, widget.createdAt, favorite);
      }
      catch (e) {
        if (!context.mounted) return;
        _showSnackBar(context, "Error updating recipe");
      }
    }
    else {
      try {
        _recipeController.editRecipe(_nameController.text.trim(), _imageUrl!, tags, ingredients, steps, widget.createdAt, favorite);
      }
      catch (e) {
        if (!context.mounted) return;
        _showSnackBar(context, "Error updating recipe");
      }
    }  
  }

  Future<void> _pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image!.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) {
      return null;
    }
    try {
      String fileName = basename(_imageFile!.path);
      Reference storageRef = FirebaseStorage.instance.ref().child('recipe_images/$fileName');

      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> _deleteImage(String? imageUrl) async{
    try {
      if (imageUrl != null) {
        Reference storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();
      }
    } catch (e) { return; }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _createIngredientsMap() {
    for (int i = 0; i < ingredientNames.length; i++) {
      ingredients.add({
        'name': ingredientNames[i].text.trim(),
        'amount': ingredientAmounts[i].text.trim()
      });
    }
  }

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
    if (!tags.contains(tag)) {
      setState(() {
        tags.add(tag);
        _selectedTag = null;
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      tags.remove(tag);
    });
  }

  @override
  void initState() {
    super.initState();
    _getRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
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
                onPressed: _pickImage, 
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
                items: availableTags
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
                onPressed: () async {
                  await _editRecipe(context);
                  widget.onClose(); // Close the screen
                }, 
                style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF157145)),
                        foregroundColor: WidgetStateProperty.all<Color>(Color(0xFFFFFFFF)),
                ),
                child: Text("Save Recipe"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
