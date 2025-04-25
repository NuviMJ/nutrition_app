// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Sign in with email and password
//   Future<UserCredential?> signInWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       return await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//     } catch (e) {
//       print('Sign in error: $e');
//       return null;
//     }
//   }

//   // Register with email and password
//   Future<UserCredential?> registerWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       return await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//     } catch (e) {
//       print('Registration error: $e');
//       return null;
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   // Stream to track auth state changes
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
// }