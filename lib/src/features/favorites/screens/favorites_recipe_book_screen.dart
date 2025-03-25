import 'package:flutter/material.dart';
import '../../home/models/recipe.dart';
import '../../../utils/widgets/recipe_item.dart';

class FavoriteRecipeBookScreen extends StatefulWidget {
  final List<Recipe> recipes;

  const FavoriteRecipeBookScreen({super.key, required this.recipes});

  @override
  FavoriteRecipeBookScreenState createState() => FavoriteRecipeBookScreenState();
}

class FavoriteRecipeBookScreenState extends State<FavoriteRecipeBookScreen> {
  final PageController  _pageController = PageController();
  final TextEditingController _pageTextController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  int recipesPerPage = 6;
  int currPage = 0;

  int get totalPages => (widget.recipes.length / recipesPerPage).ceil();

  List<Recipe> filteredRecipes = [];

  //Navigates to the page of recipes specificed by the user, must be between 0 and the number of recipes/6
  void _jumpToPage(int page) {
    if (page >= 0 && page < totalPages) {
      _pageController.jumpToPage(page);
      setState(() => currPage = page);
    }
  }

  void filterRecipes(String query) {
    setState(() {
      if (query.isEmpty) {filteredRecipes = List.from(widget.recipes);}
      else {
        query = query.toLowerCase();
        filteredRecipes = widget.recipes.where((recipe) {
          return recipe.name.toLowerCase().contains(query) ||
                 recipe.tags.any((tag) => tag.toLowerCase().contains(query)) ||
                 recipe.ingredients.any((ingredient) => ingredient["name"].toLowerCase().contains(query));
        }).toList();
      }
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
                      "My Favorite Recipes",
                      style: TextStyle(
                        fontFamily: "JustAnotherHand",
                        fontSize: 30,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: "Search Recipes",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                          ),
                          onChanged: filterRecipes,
                        )
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
                      separatorBuilder: (context, index) => SizedBox(height: 26),
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
      ],
    );
  }
}