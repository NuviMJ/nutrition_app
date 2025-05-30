import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodies/pages/login_page.dart';
import 'package:foodies/pages/landingpage.dart';  // Your updated landing page with navigation logic
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FoodiesApp());
}

class FoodiesApp extends StatelessWidget {
  const FoodiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodies',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.herbalTheme,
      home: const LandingPage(),
      routes: {
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
