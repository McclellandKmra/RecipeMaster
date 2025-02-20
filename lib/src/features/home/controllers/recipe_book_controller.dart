import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecipeBookController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addRecipe(String name, String imageUrl, List<String> tags, List<Map<String, String>> ingredients, List<TextEditingController> steps) async{
    try {
      //Get current user's ID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Error fetching user');
      }
      String userID = user.uid;

      List<String> stepTexts = steps.map((controller) => controller.text).toList();

      //Specify the subcollection path
      CollectionReference userRecipesCollection = firestore.collection('users').doc(userID).collection('recipes');

      await userRecipesCollection.add({
        'name': name,
        'imageUrl': imageUrl,
        'tags': tags,
        'createdAt': FieldValue.serverTimestamp() ,
        'ingredients': ingredients,
        'steps': stepTexts
      });
    } 
    catch(e) {
      throw Exception('Error adding recipe');
    }
  }
}