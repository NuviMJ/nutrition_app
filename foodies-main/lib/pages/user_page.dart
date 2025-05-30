import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

/// Basic Flutter App wrapper
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Demo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const UserPage(),
    );
  }
}

/// ---------------------------
/// UserPage: Profile view page
/// ---------------------------
class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final firestore = FirebaseFirestore.instance;

  String? displayName;
  String? birthday;
  String? photoURL;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final doc = await firestore.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      displayName = data['displayName'] ?? user.displayName ?? 'No username';
      birthday = data['birthday'] ?? 'Not set';
      photoURL = data['photoURL'] ?? user.photoURL;
    } else {
      displayName = user.displayName ?? 'No username';
      birthday = 'Not set';
      photoURL = user.photoURL;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _navigateToEdit() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          currentDisplayName: displayName ?? '',
          currentBirthday: birthday ?? '',
          currentPhotoURL: photoURL,
        ),
      ),
    );

    // Reload if profile updated
    if (updated == true) {
      _loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEdit,
            tooltip: 'Edit Profile',
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.green,
            backgroundImage: photoURL != null ? NetworkImage(photoURL!) : null,
            child: photoURL == null ? const Icon(Icons.person, size: 50) : null,
          ),
          const SizedBox(height: 16),
          Text(
            displayName ?? 'No username',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            birthday ?? 'Not set',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            user.email ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          // Posts grid
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('posts')
                  .where('userId', isEqualTo: user.uid)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No posts yet'));
                }

                final posts = snapshot.data!.docs;

                return GridView.builder(
                  padding: const EdgeInsets.all(4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final imageUrl = post['imageUrl'] ?? '';

                    return GestureDetector(
                      onTap: () {
                        // Optional: open fullscreen or details
                      },
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------
/// EditProfilePage: Edit interface
/// ------------------------------
class EditProfilePage extends StatefulWidget {
  final String currentDisplayName;
  final String currentBirthday;
  final String? currentPhotoURL;

  const EditProfilePage({
    super.key,
    required this.currentDisplayName,
    required this.currentBirthday,
    this.currentPhotoURL,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  late TextEditingController _nameController;
  late TextEditingController _birthdayController;

  String? profileImageUrl;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentDisplayName);
    _birthdayController = TextEditingController(text: widget.currentBirthday);
    profileImageUrl = widget.currentPhotoURL;
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);

      final ref = storage.ref().child('profile_pictures/${user.uid}.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      setState(() {
        profileImageUrl = url;
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      isSaving = true;
    });

    final newName = _nameController.text.trim();
    final newBirthday = _birthdayController.text.trim();

    await firestore.collection('users').doc(user.uid).set({
      'displayName': newName,
      'birthday': newBirthday,
      'photoURL': profileImageUrl,
      'email': user.email,
    }, SetOptions(merge: true));

    await user.updateDisplayName(newName);
    if (profileImageUrl != null) {
      await user.updatePhotoURL(profileImageUrl);
    }

    setState(() {
      isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );

    Navigator.pop(context, true); // signal update to UserPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (!isSaving)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
              tooltip: 'Save Profile',
            )
        ],
      ),
      body: isSaving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green,
                      backgroundImage:
                          profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
                      child: profileImageUrl == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Display Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _birthdayController,
                    decoration: const InputDecoration(labelText: 'Birthday (YYYY-MM-DD)'),
                  ),
                ],
              ),
            ),
    );
  }
}
