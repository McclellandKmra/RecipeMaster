import 'package:cloud_firestore/cloud_firestore.dart';
class Recipe{
  final String name;
  final String imageUrl;
  final List<String> tags;
  final DateTime? createdAt;
  List<Map<String, dynamic>> ingredients;
  List<String> steps;

  Recipe({required this.name, required this.imageUrl, required this.tags, required this.createdAt, required this.ingredients, required this.steps});

  factory Recipe.fromMap(Map<String, dynamic> data) {
    Timestamp? timestamp = data['createdAt'] as Timestamp?;
    DateTime? createdAtDateTime;

    if (timestamp != null) {
      createdAtDateTime = timestamp.toDate();
    }
    
    return Recipe(
      name: data['name']  ?? '',
      imageUrl: data['imageUrl']  ?? '',
      tags: List<String>.from(data['tags']  ?? []),
      createdAt: createdAtDateTime,
      ingredients: List<Map<String, dynamic>>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'])
    );
  }
}