import 'package:flutter/material.dart';
import '../../utils/widgets/navigation_drawer.dart' as custom;
import '../home/controllers/home_controller.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  final HomeController homeController = HomeController();

  Future<void> deleteAccount(BuildContext context) async {
    homeController.handleSignout(context);

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            "Account",
            style: TextStyle(
              fontFamily: "JustAnotherHand",
              fontSize: 45,
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/Background.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: 
                  () => showDialog<String>(
                    context: context,
                    builder:
                        (BuildContext context) => AlertDialog(
                          actionsOverflowAlignment: OverflowBarAlignment.center,
                          title: Text('Delete Account?'),
                          content: const Text('This action cannot be undone.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'OK');
                                deleteAccount(context);
                              },
                              child: const Text('Delete'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 202, 52, 52)),
                foregroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)),
              ),
              child: Text("Delete Account")
            ),
          ),
        ],
      ),
    );
  } 
}