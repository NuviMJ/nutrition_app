// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:nutrition_app/features/auth/presentation/pages/login_page.dart';
// import 'package:nutrition_app/firebase_options.dart';
// import 'package:nutrition_app/themes/light_mode.dart';

// void main() async {
//   //firebase setup
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// //app run
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: lightMode,
//        home: LoginPage(),
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/app.dart';
import 'package:nutrition_app/firebase_options.dart';

void main() async {
  //firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//app run
  runApp( MyApp());
}

