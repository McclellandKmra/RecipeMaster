import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../../../utils/widgets/recipe_item.dart';
import 'create_recipe.dart';

class RecipeBookScreen extends StatefulWidget {
  final List<Recipe> recipes;

  const RecipeBookScreen({super.key, required this.recipes});

  @override
  RecipeBookScreenState createState() => RecipeBookScreenState();
}

//Displays all recipes, 6 per page.
class RecipeBookScreenState extends State<RecipeBookScreen> {
  final PageController  _pageController = PageController();
  final TextEditingController _pageTextController = TextEditingController();
  bool _isAddingRecipe = false;

  int recipesPerPage = 6;
  int currPage = 0;

  int get totalPages => (widget.recipes.length / recipesPerPage).ceil();

  void _jumpToPage(int page) {
    if (page >= 0 && page < totalPages) {
      _pageController.jumpToPage(page);
      setState(() => currPage = page);
    }
  }

  void _onClose() {
    setState(() {
      _isAddingRecipe = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/RecipeListPaper.png"), // Add this image to your assets
            fit: BoxFit.cover
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 3), // Adjust padding as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Recipes",
                      style: TextStyle(
                        fontFamily: "JustAnotherHand",
                        fontSize: 30,
                      ),
                    ),
                    Padding (
                      padding: const EdgeInsets.only(right: 5.0),
                      child: IconButton(
                        icon: Icon(Icons.add_box_rounded),
                        iconSize: 30,
                        
                        onPressed: () {
                          setState(() {
                            _isAddingRecipe = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 13),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: totalPages,
                  onPageChanged: (index) => setState(() => currPage = index),
                  itemBuilder: (context, pageIndex) {
                    int start = pageIndex * recipesPerPage;
                    int end = (start + recipesPerPage).clamp(0, widget.recipes.length);
                    List<Recipe> pageRecipes = widget.recipes.sublist(start, end);
                    return ListView.separated(
                      itemCount: pageRecipes.length,
                      itemBuilder: (context, index) {
                        return RecipeItem(recipe: pageRecipes[index]);
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 28),
                    );
                  }
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: currPage > 0 ? () => _jumpToPage(currPage - 1) : null,
                  ),
                  Text("Page ${currPage + 1} of $totalPages"),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: currPage < totalPages - 1 ? () => _jumpToPage(currPage + 1) : null,
                  ),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _pageTextController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        int? page = int.tryParse(value);
                        if (page != null) _jumpToPage(page - 1);
                      },
                      decoration: InputDecoration(hintText: "Go"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        if (_isAddingRecipe) 
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5), // Semi-transparent background
              child: Center(
                child: CreateRecipeScreen(onClose: _onClose), // Pass onClose function
              ),
            )
          )
      ],
    );
  }
}