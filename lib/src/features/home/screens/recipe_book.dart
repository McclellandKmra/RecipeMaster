import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../../../utils/widgets/recipe_item.dart';

class RecipeBookScreen extends StatefulWidget {
  final List<Recipe> recipes;

  const RecipeBookScreen({super.key, required this.recipes});

  @override
  _RecipeBookScreenState createState() => _RecipeBookScreenState();
}

class _RecipeBookScreenState extends State<RecipeBookScreen> {
  final PageController  _pageController = PageController();
  final TextEditingController _pageTextController = TextEditingController();

  int recipesPerPage = 6;
  int currPage = 0;

  int get totalPages => (widget.recipes.length / recipesPerPage).ceil();

  void _jumpToPage(int page) {
    if (page >= 0 && page < totalPages) {
      _pageController.jumpToPage(page);
      setState(() => currPage = page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/RecipeListPaper.png"), // Add this image to your assets
        fit: BoxFit.cover
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 65),
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
                    return RecipeItem(pageRecipes[index]);
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
    );
  }
}