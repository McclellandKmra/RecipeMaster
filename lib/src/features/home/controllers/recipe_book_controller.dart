import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeBookController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addRecipe(String name, String imageUrl, List<String> tags) async{
    try {
      //Get current user's ID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Error fetching user');
      }
      String userID = user.uid;

      //Specify the subcollection path
      CollectionReference userRecipesCollection = firestore.collection('users').doc(userID).collection('recipes');

      await userRecipesCollection.add({
        'name': name,
        'imageUrl': imageUrl,
        'tags': tags,
        'createdAt': FieldValue.serverTimestamp() 
      });
    } 
    catch(e) {
      throw Exception('Error adding recipe');
    }
  }
}