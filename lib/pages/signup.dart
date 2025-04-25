// // import 'package:flutter/material.dart';
// // //import 'package:firebase_auth/firebase_auth.dart';
// // import '../services/auth_service.dart';  // Assuming you have the AuthService class

// // class SignUpPage extends StatefulWidget {
// //   const SignUpPage({super.key});

// //   @override
// //   State<SignUpPage> createState() => _SignUpPageState();
// // }

// // class _SignUpPageState extends State<SignUpPage> {
// //   final _fullNameController = TextEditingController();
// //   final _emailController = TextEditingController();
// //   final _passwordController = TextEditingController();
// //   final _confirmPasswordController = TextEditingController();

// //   bool _obscurePassword = true;
// //   bool _obscureConfirmPassword = true;
// //   bool _isLoading = false;

// //   final AuthService _authService = AuthService();

// //   // Sign-up logic
// //   Future<void> _signUp() async {
// //     final email = _emailController.text;
// //     final password = _passwordController.text;
// //     final confirmPassword = _confirmPasswordController.text;

// //     // Check if passwords match
// //     if (password != confirmPassword) {
// //       _showErrorMessage('Passwords do not match');
// //       return;
// //     }

// //     setState(() {
// //       _isLoading = true;
// //     });

// //     // Register the user with Firebase Authentication
// //     try {
// //       final userCredential = await _authService.registerWithEmailAndPassword(email, password);
      
// //       if (userCredential != null) {
// //         // Successfully signed up, you can redirect or show a success message
// //         Navigator.pushReplacementNamed(context, '/home'); // Assuming '/home' is your home screen route
// //       } else {
// //         _showErrorMessage('Sign up failed');
// //       }
// //     } catch (e) {
// //       _showErrorMessage('Error: $e');
// //     } finally {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }

// //   // Function to show error messages
// //   void _showErrorMessage(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.symmetric(horizontal: 24.0),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               SizedBox(height: 80),

// //               // Sign Up Title
// //               Text(
// //                 'Sign up',
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(
// //                   fontSize: 24,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               SizedBox(height: 32),

// //               // Full Name TextField
// //               TextField(
// //                 controller: _fullNameController,
// //                 decoration: InputDecoration(
// //                   hintText: 'Full Name',
// //                   prefixIcon: Icon(Icons.person_outline),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 16),

// //               // Email TextField
// //               TextField(
// //                 controller: _emailController,
// //                 decoration: InputDecoration(
// //                   hintText: 'Email',
// //                   prefixIcon: Icon(Icons.email_outlined),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //                 keyboardType: TextInputType.emailAddress,
// //               ),
// //               SizedBox(height: 16),

// //               // Password TextField
// //               TextField(
// //                 controller: _passwordController,
// //                 obscureText: _obscurePassword,
// //                 decoration: InputDecoration(
// //                   hintText: 'Password',
// //                   prefixIcon: Icon(Icons.lock_outline),
// //                   suffixIcon: IconButton(
// //                     icon: Icon(_obscurePassword
// //                         ? Icons.visibility_off
// //                         : Icons.visibility),
// //                     onPressed: () {
// //                       setState(() {
// //                         _obscurePassword = !_obscurePassword;
// //                       });
// //                     },
// //                   ),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 16),

// //               // Confirm Password TextField
// //               TextField(
// //                 controller: _confirmPasswordController,
// //                 obscureText: _obscureConfirmPassword,
// //                 decoration: InputDecoration(
// //                   hintText: 'Confirm Password',
// //                   prefixIcon: Icon(Icons.lock_outline),
// //                   suffixIcon: IconButton(
// //                     icon: Icon(_obscureConfirmPassword
// //                         ? Icons.visibility_off
// //                         : Icons.visibility),
// //                     onPressed: () {
// //                       setState(() {
// //                         _obscureConfirmPassword = !_obscureConfirmPassword;
// //                       });
// //                     },
// //                   ),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 70),

// //               // Sign Up Button
// //               ElevatedButton(
// //                 onPressed: _isLoading ? null : _signUp,
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.green[900],
// //                   padding: EdgeInsets.symmetric(vertical: 16),
// //                   minimumSize: Size(double.infinity, 50),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //                 child: _isLoading
// //                     ? CircularProgressIndicator(color: Colors.white)
// //                     : Text('Sign Up', style: TextStyle(color: Colors.white)),
// //               ),
// //               SizedBox(height: 16),

// //               // Login redirect
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Text("Already have an account? "),
// //                   GestureDetector(
// //                     onTap: () {
// //                       // Navigate back to login page
// //                       Navigator.pop(context);
// //                     },
// //                     child: Text(
// //                       'Login',
// //                       style: TextStyle(
// //                         color: Colors.green[900],
// //                         fontWeight: FontWeight.bold,
// //                         decoration: TextDecoration.underline,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _isLoading = false;

//   // Sign-up logic without Firebase
//   Future<void> _signUp() async {
//     final email = _emailController.text;
//     final password = _passwordController.text;
//     final confirmPassword = _confirmPasswordController.text;

//     if (password != confirmPassword) {
//       _showErrorMessage('Passwords do not match');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     await Future.delayed(Duration(seconds: 1)); // simulate delay

//     // Just navigate for now – replace this with your own logic later
//     Navigator.pushReplacementNamed(context, '/home');

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   // Function to show error messages
//   void _showErrorMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               SizedBox(height: 80),

//               Text(
//                 'Sign up',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 32),

//               TextField(
//                 controller: _fullNameController,
//                 decoration: InputDecoration(
//                   hintText: 'Full Name',
//                   prefixIcon: Icon(Icons.person_outline),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),

//               TextField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   hintText: 'Email',
//                   prefixIcon: Icon(Icons.email_outlined),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               SizedBox(height: 16),

//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscurePassword,
//                 decoration: InputDecoration(
//                   hintText: 'Password',
//                   prefixIcon: Icon(Icons.lock_outline),
//                   suffixIcon: IconButton(
//                     icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),

//               TextField(
//                 controller: _confirmPasswordController,
//                 obscureText: _obscureConfirmPassword,
//                 decoration: InputDecoration(
//                   hintText: 'Confirm Password',
//                   prefixIcon: Icon(Icons.lock_outline),
//                   suffixIcon: IconButton(
//                     icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
//                     onPressed: () {
//                       setState(() {
//                         _obscureConfirmPassword = !_obscureConfirmPassword;
//                       });
//                     },
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 70),

//               ElevatedButton(
//                 onPressed: _isLoading ? null : _signUp,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green[900],
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   minimumSize: Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? CircularProgressIndicator(color: Colors.white)
//                     : Text('Sign Up', style: TextStyle(color: Colors.white)),
//               ),
//               SizedBox(height: 16),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Already have an account? "),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text(
//                       'Login',
//                       style: TextStyle(
//                         color: Colors.green[900],
//                         fontWeight: FontWeight.bold,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
