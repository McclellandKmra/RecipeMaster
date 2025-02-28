import 'package:flutter/material.dart';
import 'package:recipemaster/src/features/recipeDetails/screens/recipe_details_screen.dart';
import '../../features/home/models/recipe.dart';
import '../../features/recipeDetails/screens/recipe_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeItem extends StatelessWidget {
  final Recipe recipe;
  const RecipeItem(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        tileColor: Color.fromARGB(255, 216, 204, 170),
        leading: SizedBox(
          width: 50,
          height: 50,
          child: CachedNetworkImage(
            imageUrl: recipe.imageUrl, 
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )
        ),
        title: Text(recipe.name),
        subtitle: Text(recipe.tags.join(", ")),
        trailing: Icon(
          recipe.favorite ? Icons.star : Icons.star_border,
          color: recipe.favorite ? Colors.yellow : null
        ),
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