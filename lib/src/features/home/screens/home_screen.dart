import 'package:flutter/material.dart';
//import '../controllers/home_controller.dart';
import '../../../utils/widgets/navigation_drawer.dart' as custom;
import 'recipe_book.dart';
import '../models/recipe.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //final HomeController _controller = HomeController();

  final List<Recipe> recipes = [
     Recipe(
      imageUrl: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTknpx5O_1wniDECeS2QHTqNSQKnbhuWSsgJ4nPi9GE1uHFj9GAAx5-8ha-VEh84gbc7PzQSb0Uf4bXG-ZDTNZILZ0AHjdZgXng0hirTfE",
      name: "Spaghetti Carbonara",
      tags: ["Italian", "Pasta", "Quick"],
    ),
    Recipe(
      imageUrl: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTknpx5O_1wniDECeS2QHTqNSQKnbhuWSsgJ4nPi9GE1uHFj9GAAx5-8ha-VEh84gbc7PzQSb0Uf4bXG-ZDTNZILZ0AHjdZgXng0hirTfE",
      name: "Spaghetti Carbonara",
      tags: ["Italian", "Pasta", "Quick"],
    ),
    Recipe(
      imageUrl: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTknpx5O_1wniDECeS2QHTqNSQKnbhuWSsgJ4nPi9GE1uHFj9GAAx5-8ha-VEh84gbc7PzQSb0Uf4bXG-ZDTNZILZ0AHjdZgXng0hirTfE",
      name: "Spaghetti Carbonara",
      tags: ["Italian", "Pasta", "Quick"],
    ),
    Recipe(
      imageUrl: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTknpx5O_1wniDECeS2QHTqNSQKnbhuWSsgJ4nPi9GE1uHFj9GAAx5-8ha-VEh84gbc7PzQSb0Uf4bXG-ZDTNZILZ0AHjdZgXng0hirTfE",
      name: "Spaghetti Carbonara",
      tags: ["Italian", "Pasta", "Quick"],
    ),
    Recipe(
      imageUrl: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTknpx5O_1wniDECeS2QHTqNSQKnbhuWSsgJ4nPi9GE1uHFj9GAAx5-8ha-VEh84gbc7PzQSb0Uf4bXG-ZDTNZILZ0AHjdZgXng0hirTfE",
      name: "Spaghetti Carbonara",
      tags: ["Italian", "Pasta", "Quick"],
    ),
    Recipe(
      imageUrl: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTknpx5O_1wniDECeS2QHTqNSQKnbhuWSsgJ4nPi9GE1uHFj9GAAx5-8ha-VEh84gbc7PzQSb0Uf4bXG-ZDTNZILZ0AHjdZgXng0hirTfE",
      name: "Spaghetti Carbonara",
      tags: ["Italian", "Pasta", "Quick"],
    ),
    Recipe(
      imageUrl: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTknpx5O_1wniDECeS2QHTqNSQKnbhuWSsgJ4nPi9GE1uHFj9GAAx5-8ha-VEh84gbc7PzQSb0Uf4bXG-ZDTNZILZ0AHjdZgXng0hirTfE",
      name: "Spaghetti Carbonara",
      tags: ["Italian", "Pasta", "Quick"],
    ),
    Recipe(
      imageUrl: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTknpx5O_1wniDECeS2QHTqNSQKnbhuWSsgJ4nPi9GE1uHFj9GAAx5-8ha-VEh84gbc7PzQSb0Uf4bXG-ZDTNZILZ0AHjdZgXng0hirTfE",
      name: "Spaghetti Carbonara",
      tags: ["Italian", "Pasta", "Quick"],
    ),
    // Add more recipes as needed
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Color.fromARGB(255, 78, 143, 163),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/images/Logo.png',
              height: 40,
            ),
          ),
        ],
      ),
      drawer: custom.NavigationDrawer(),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset( //Background Image
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RecipeBookScreen(recipes: recipes),
            ),
          ),
        ],
      ),
    );
  }
}
