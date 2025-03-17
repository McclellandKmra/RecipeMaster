import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RecipeDetailsController {
  Future<void> deleteRecipe(BuildContext context,  String userId, String? recipeId, String? imageUrl) async{
    try {
      if (imageUrl != null) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }
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