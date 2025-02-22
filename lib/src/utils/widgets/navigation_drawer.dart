import 'package:flutter/material.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/home/screens/home_screen.dart';

final HomeController _controller = HomeController();

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFFAD87A),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }
}

Widget buildHeader(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ),
  );
}

Widget buildMenuItems(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      runSpacing: 16,
      children: [
        ListTile(
          leading: const Icon(Icons.home_filled),
          title: const Text('Home'),
          onTap: (){
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
          },
        ),
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text('Favorites'),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.tag),
          title: const Text('Edit Recipe Tags'),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.person_2_outlined),
          title: const Text('Account'),
          onTap: (){},
        ),
        const Divider(color: Colors.black),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log Out'),
          onTap: () => _controller.handleSignout(context),
        ),
      ],
    ),
  );
}