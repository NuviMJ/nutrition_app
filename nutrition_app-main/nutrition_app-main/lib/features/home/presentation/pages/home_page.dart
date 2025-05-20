import 'package:flutter/material.dart';
import 'package:nutrition_app/features/home/presentation/component/my_drawer.dart';

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
        // actions: [
          //logout button
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: () {
          //     context.read<AuthCubit>().logout();
          //   },
          // ),
        // ],
      ),
      //Drawer
      drawer: const MyDrawer(),
    );
  }
}
