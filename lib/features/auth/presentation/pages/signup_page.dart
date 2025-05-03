import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _pwController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

Future<void> signUp() async {
  // 1. Get and sanitize inputs
  final rawEmail = _emailController.text;
  final email = rawEmail
    .trim()
    .replaceAll(RegExp(r'[\u200E\u200F]'), ''); // Remove RTL marks

  // 2. Deep debug
  debugPrint('''
=== EMAIL DEBUG INFO ===
Raw input: "$rawEmail" 
  - Length: ${rawEmail.length}
  - Code units: ${rawEmail.codeUnits}
Sanitized: "$email"
  - Length: ${email.length}
  - Code units: ${email.codeUnits}
''');

  // 3. Validation
  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
    debugPrint('FAILED REGEX VALIDATION');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid email format'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // 4. Firebase test
//   try {
//     setState(() => _isLoading = true);
//     debugPrint('Attempting Firebase registration...');
    
//     await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: email,
//       password: _pwController.text.trim(),
//     );
    
//     debugPrint('Registration successful!');
//   } on FirebaseAuthException catch (e) {
//     debugPrint('FIREBASE ERROR: ${e.code} - ${e.message}');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Firebase error: ${e.message}'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   } finally {
//     if (mounted) setState(() => _isLoading = false);
//   }
// }
 
   // 4. Firebase test
  try {
    setState(() => _isLoading = true);
    debugPrint('Attempting Firebase registration...');
    
    // Create user in Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: _pwController.text.trim(),
    );
    
    debugPrint('Authentication registration successful!');
    
    // IMPORTANT: Create a document in Firestore with the same user ID
    final uid = userCredential.user!.uid;
    final name = _fullNameController.text.trim(); // Assuming you have a name field
    
    debugPrint('Creating Firestore profile for user: $uid');
    
    // Create user profile document in Firestore
    debugPrint('Attempting to create user profile...'); 
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name.isNotEmpty ? name : 'User', // Use name if available
      'email': email,
      'photoUrl': '',
      'bio': '',
      'createdAt': FieldValue.serverTimestamp(),
      // Add any other fields you need for your app
    });
    
    debugPrint('Firestore profile created successfully!');
    
  } on FirebaseAuthException catch (e) {
    debugPrint('FIREBASE AUTH ERROR: ${e.code} - ${e.message}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Firebase error: ${e.message}'),
        backgroundColor: Colors.red,
      ),
    );
  } catch (e) {
    // This will catch Firestore errors or other exceptions
    debugPrint('OTHER ERROR: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),
              const Text(
                'Sign up',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pwController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              ElevatedButton(
                onPressed: _isLoading ? null : signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[900],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}