import 'package:flutter/material.dart';
import 'package:nutrition_app/pages/login.dart';

void main() {
  runApp(MyApp()
  //   MaterialApp(
  //   debugShowCheckedModeBanner: false,
  //   home: MyApp(),
  // )
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}