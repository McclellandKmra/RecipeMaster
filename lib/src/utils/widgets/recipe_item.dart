import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:marquee/marquee.dart';
import 'package:recipemaster/src/features/recipeDetails/screens/recipe_details_screen.dart';
import '../../features/home/models/recipe.dart';

//Class for each item in the recipe book. Displays the name, image, tags, and its favorited status. Can be clicked on for full recipe details
class RecipeItem extends StatelessWidget {
  final Recipe recipe;
  const RecipeItem({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        tileColor: Color.fromARGB(255, 216, 204, 170),
        leading: SizedBox(
          width: 50,
          height: 50,
          //Uses the Cached Network Image package to hopefully reduce image loading times. Uses progress indicator to indicate loading
          child: CachedNetworkImage(
            imageUrl: recipe.imageUrl, 
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            //Measure the width of the text
            final textPainter = TextPainter(
              text: TextSpan(
                text: recipe.name,
                style: TextStyle(fontSize: 16),
              ),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: constraints.maxWidth);

            //Check if the text overflows (ie is longer than 1 line)
            final isOverflowing = textPainter.didExceedMaxLines;

            //Use Marquee if overflowing, otherwise use Text
            return isOverflowing
                ? SizedBox(
                    height: 20,
                    child: Marquee(
                      text: recipe.name,
                      style: TextStyle(fontSize: 16),
                      scrollAxis: Axis.horizontal,
                      blankSpace: 20.0,
                      velocity: 20.0,
                      pauseAfterRound: Duration(seconds: 1),
                      startPadding: 10.0,
                      accelerationDuration: Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),
                  )
                : Text(
                    recipe.name,
                    style: TextStyle(fontSize: 16),
                  );
          },
        ),
        subtitle: Text(recipe.tags.join(", ")),
        trailing: Icon(
          recipe.favorite ? Icons.star : Icons.star_border,
          color: recipe.favorite ? Colors.yellow : null
        ),
        //Navigates the user to the recipe details page
        onTap: (){
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailsScreen(recipeName: recipe.name, createdAt: recipe.createdAt),
            ),
           );
        },
      )
    );
  }
}