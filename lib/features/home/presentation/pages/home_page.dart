import 'package:flutter/material.dart';
import 'package:nutrition_app/features/home/presentation/component/my_drawer.dart';
import 'package:nutrition_app/features/post/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          //upload new post button
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadPostPage(),
              ),
            )
          ),
        ],
      ),
      //Drawer
      drawer: const MyDrawer(),
    );
  }
}
