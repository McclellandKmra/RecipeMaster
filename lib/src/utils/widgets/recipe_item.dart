import 'package:flutter/material.dart';
import 'package:recipemaster/src/features/recipeDetails/screens/recipe_details_screen.dart';
import '../../features/home/models/recipe.dart';
import '../../features/recipeDetails/screens/recipe_details_screen.dart';

class RecipeItem extends StatelessWidget {
  final Recipe recipe;
  const RecipeItem(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        tileColor: Color.fromARGB(255, 216, 204, 170),
        leading: Image.network(recipe.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(recipe.name),
        subtitle: Text(recipe.tags.join(", ")),
        trailing: Icon(Icons.star_border),
        onTap: (){
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailsScreen(recipeName: recipe.name),
            ),
           );
        },
      )
    );
  }
}