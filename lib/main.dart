import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodies/pages/home_page.dart';
import 'package:foodies/pages/landingpage.dart';
// Your updated landing page with navigation logic
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
 mvd-perera-comment-and-landing
      //  home: const HomePage(),
      home: const LandingPage(),
      routes: {
        // '/login': (context) => const LoginPage(),
      },

      home: const HomePage(),
      //home: const LandingPage(),
       routes: {
         '/login': (context) => const LoginPage(),
       },
 main
    );
  }
}
