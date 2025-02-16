import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeBookController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addRecipe(String name, String imageUrl, List<String> tags) async{
    try {
      await firestore.collection('recipes').add({
        'name': name,
        'imageUrl': imageUrl,
        'tags': tags
      });
    } catch(e) {}

  }
}