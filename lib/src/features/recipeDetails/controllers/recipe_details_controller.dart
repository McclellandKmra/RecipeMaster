import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RecipeDetailsController {
  //Deletes the recipe from firestore, and its image from firebase storage
  Future<void> deleteRecipe(BuildContext context,  String userId, String? recipeId, String? imageUrl) async{
    try {
      //If the image URL exists, remove it from firebase storage
      if (imageUrl != null) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }
      //If the recipe ID exists (it always should), delete the recipe from firestore
      if (recipeId != null) {
        await FirebaseFirestore.instance.collection("users").doc(userId).collection("recipes").doc(recipeId).delete();
      }
      if (context.mounted) Navigator.pop(context, 'OK');
    }
    catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, "Recipe Deletion Failed");
    }
  }

  //For error messages
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}