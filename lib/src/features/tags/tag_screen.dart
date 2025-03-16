import 'package:flutter/material.dart';
import '../../utils/widgets/navigation_drawer.dart' as custom;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TagScreen extends StatefulWidget {
  const TagScreen({super.key});

  @override
  TagScreenState createState() => TagScreenState();
}

class TagScreenState extends State<TagScreen> {
  List<String> tags = [];
  bool isCreatingTag = false;
  final TextEditingController _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTags();
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

  Future<void> fetchTags() async{
    try {
      List<String> userTags = [];
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

      setState(() {
        tags = userTags;
      });

    }
    catch (e) { 
      return; 
    }
  }

  Future<void> createTag(BuildContext context, String tag) async{
    //Get user id
    String userId = await getUserId();

    //Firebase query
    final userTags = FirebaseFirestore.instance.collection("users").doc(userId);
    try {
      await userTags.update({'Tags': FieldValue.arrayUnion([tag])});
      setState(() {
        tags.add(tag);
        isCreatingTag = false;
        _tagController.clear();
      });
    }
    catch (e) { return; } 
  }

  Future<void> deleteTag(BuildContext context, String tag) async{
    //Get user id
    String userId = await getUserId();

    //Firebase query
    final userTags = FirebaseFirestore.instance.collection("users").doc(userId);
    try {
      await userTags.update({'Tags': FieldValue.arrayRemove([tag])});
      setState(() {
        tags.remove(tag);
      });
    }
    catch (e) { return; } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            "My Tags",
            style: TextStyle(
              fontFamily: "JustAnotherHand",
              fontSize: 42,
            ),
          ),
        ),
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
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
              // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/Background.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/Paper.png'),
                                fit: BoxFit.fill
                              ),
                              borderRadius: BorderRadius.circular(15)
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Center( 
                                  child: IconButton(
                                    icon: Icon(Icons.add_box_rounded, size: 30),
                                    onPressed: () {
                                      setState(() {
                                        isCreatingTag = true;
                                      });
                                    },
                                  ),
                                ),
                                if (isCreatingTag) ...[
                                  SizedBox(height: 20),
                                  TextField (
                                    controller: _tagController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    onSubmitted: (tag) {
                                      if (tag.isNotEmpty) {
                                        createTag(context, tag);
                                      }
                                    },
                                  ),
                                ],
                                SizedBox(height: 20),
                                Wrap(
                                  spacing: 8.0,
                                  children: tags.map((tag) => Chip(
                                    label: Text(tag),
                                    backgroundColor: Colors.green[200],
                                    deleteIcon: Icon(Icons.close),
                                    onDeleted: () {
                                      deleteTag(context, tag);
                                    },
                                  )).toList(),
                                ),
                              ],
                            ),  
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}