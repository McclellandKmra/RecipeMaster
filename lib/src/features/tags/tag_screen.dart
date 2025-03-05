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

  @override
  void initState() {
    super.initState();
    fetchTags();
  }

  Future<void> fetchTags() async{
    try {
      List<String> userTags = [];
      //Get user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) { throw Exception('Error fetching user'); }
      String userId = user.uid;

      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc(userId).get();
      if (snapshot.exists) {
        userTags = snapshot.get("tags");
      }

      setState(() {
        tags = userTags;
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
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/Paper.png'),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        padding: EdgeInsets.all(16),
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