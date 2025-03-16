import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecipeBookController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addRecipe(String name, String imageUrl, List<String> tags, List<Map<String, dynamic>> ingredients, List<TextEditingController> steps, bool favorite) async{
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
        'steps': stepTexts,
        'favorite' : favorite
      });
    } 
    catch(e) {
      throw Exception('Error adding recipe');
    }
  }

  Future<void> editRecipe(String name, String imageUrl, List<String> tags, List<Map<String, dynamic>> ingredients, List<TextEditingController> steps, bool favorite) async {
    try {
      String userId = await getUserId();

      String? recipeId = await getRecipeId(name, userId);

      List<String> stepTexts = steps.map((controller) => controller.text).toList();

      //Specify the document path
      DocumentReference recipeDocument = firestore.collection('users').doc(userId).collection('recipes').doc(recipeId);

      //Logic to update the database values
      await recipeDocument.update ({
        "name" : name,
        "tags" : tags,
        "ingredients" : ingredients,
        "steps" : stepTexts,
        "imageUrl" : imageUrl,
        "timestamp" : FieldValue.serverTimestamp(),
        "favorite" : favorite
      });
    } 
    catch(e) {
      throw Exception('Error adding recipe');
    }
  }

  Future<String?> getRecipeId(String recipeName, String userID) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users').doc(userID).collection('recipes')
        .where('name', isEqualTo: recipeName)
        .limit(1)
        .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      }
      else {
        return null;
      }
    }
    catch (e) {
      return null;
    }
  }

  Future<String> getUserId() async {
    //Get user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) { 
        throw Exception('Error fetching user'); 
      }
      String userId = user.uid;
      return userId;
  }

  Future<List<String>> fetchTags() async{
    List<String> userTags = [];
    try {
      String userId = await getUserId();
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc(userId).get();
      if (snapshot.exists) {   
        var data = snapshot.data() as Map<String, dynamic>; // Ensure it's a Map
        if (data.containsKey("Tags") || data.containsKey("tags")) {
          if (data["Tags"] is List) {
            userTags = List<String>.from(data["Tags"]); // Ensure correct type
          }
          else if (data["tags"] is List) {
            userTags = List<String>.from(data["tags"]); // Ensure correct type
          }
          else {
            userTags = []; // Default to empty list if missing
          }
        } 
        else {
           userTags = []; // Default to empty list if missing
        }
      }
      return userTags;
    }
    catch (e) { 
      return userTags; 
    }
  }
}