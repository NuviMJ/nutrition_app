// import 'package:flutter/material.dart';
// import 'package:nutrition_app/pages/signup.dart';

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: LoginPage(),
//   ));
// }

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     bool obscurePassword = true;
//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           children: [
//             Text(
//               'Log in',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 32),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 hintText: 'Email',
//                 prefixIcon: Icon(Icons.email_outlined),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: passwordController,
//               obscureText: obscurePassword,
//               decoration: InputDecoration(
//                 hintText: 'Password',
//                 prefixIcon: Icon(Icons.lock_outline),
//                 suffixIcon: IconButton(
//                   icon: Icon(obscurePassword
//                       ? Icons.visibility_off
//                       : Icons.visibility),
//                   onPressed: () {
//                     setState(() {
//                       obscurePassword = !obscurePassword;
//                     });
//                   },
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             SizedBox(height: 70),
//             ElevatedButton(
//               onPressed: () {
//                 // TODO: Implement login logic
//               },
//               style: ElevatedButton.styleFrom(
//                 textStyle: TextStyle(color: Colors.white),
//                 backgroundColor: Colors.green[900],
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 minimumSize: Size(
//                     double.infinity, 50), // This makes the button full width
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text(
//                 'Log in',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             SizedBox(height: 16),

//             // Sign up row
//             Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     Text("Don't have an account? "),
//     GestureDetector(
//       onTap: () {
//         // Navigate to Sign Up Page
//         Navigator.push(
//           context, 
//           MaterialPageRoute(
//             builder: (context) => SignUpPage(), 
//           ),
//         );
//       },
//       child: Text(
//         'Sign up',
//         style: TextStyle(
//           color: Colors.green[900],
//           fontWeight: FontWeight.bold,
//           decoration: TextDecoration.underline, // Optional: adds underline to make it look more like a link
//         ),
//       ),
//     ),
//   ],
// ),
//             SizedBox(height: 20),

//             // Social Login
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Logo(Logos.facebook_f),
//                 // SizedBox(width: 16),
//                 IconButton(
//                   icon: Icon(Icons.facebook, color: Colors.blue, size: 40),
//                   onPressed: () {
//                     // TODO: Implement Google Sign In
//                   },
//                 ),
//                 SizedBox(width: 16),
//                 IconButton(
//                   icon: Icon(Icons.gpp_good, color: Colors.red, size: 40),
//                   onPressed: () {
//                     // TODO: Implement Facebook Sign In
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
