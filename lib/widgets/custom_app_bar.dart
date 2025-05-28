import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.green, // ✅ Set AppBar color to green
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
