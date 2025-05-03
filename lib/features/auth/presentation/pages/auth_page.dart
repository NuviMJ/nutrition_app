import 'package:flutter/material.dart';
import 'package:nutrition_app/features/auth/presentation/pages/login_page.dart';
import 'package:nutrition_app/features/auth/presentation/pages/signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  //   with SingleTickerProviderStateMixin {
  // late AnimationController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(vsync: this);
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage();
    } else {
      return SignUpPage();
    }
  }
}
