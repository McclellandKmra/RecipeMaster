import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../../../utils/widgets/recipe_item.dart';
import '../controllers/recipe_book_controller.dart';
import 'recipe_book.dart';
import '../../../utils/widgets/ingredient_input.dart';
import '../../../utils/widgets/step_input.dart';
import '../../../constants/tags.dart';


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
  String? _selectedTag;

 

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
            ],
          ),
        ),
      ),
    );
  }
}