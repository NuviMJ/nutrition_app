import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/post_card.dart';
import 'upload_post_page.dart';
import 'user_page.dart';
import 'search_page.dart';
import 'leaderboard_page.dart';
import 'health_tips_page.dart';
import 'meals_week_page.dart';
import 'comments_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final currentUser = FirebaseAuth.instance.currentUser;

  final List<Map<String, dynamic>> defaultPosts = [
    {
      'postId': 'default1',
      'caption': 'Welcome to Foodies! Start sharing your recipes!',
      'photoUrl':
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80',
      'username': 'Admin',
      'likedBy': <String>[],
      'commentCount': 0,
    },
    {
      'postId': 'default2',
      'caption': 'Healthy meals for a better life.',
      'photoUrl':
          'https://images.unsplash.com/photo-1516685018646-5497b5c21d04?auto=format&fit=crop&w=800&q=80',
      'username': 'HealthTips',
      'likedBy': <String>[],
      'commentCount': 0,
    },
  ];

  // Map to keep track of local likedBy lists for optimistic UI updates, keyed by postId
  final Map<String, List<String>> _localLikedByMap = {};

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const UserPage()));
    }
  }

  void _navigateToUploadPostPage() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadPostPage()));
  }

  Future<void> toggleLike(String postId, bool isLiked) async {
    final userId = currentUser?.uid;
    if (userId == null) return;

    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    try {
      if (isLiked) {
        // User already liked post, so unlike it (remove userId)
        await postRef.update({
          'likedBy': FieldValue.arrayRemove([userId]),
        });
      } else {
        // User hasn't liked post, so like it (add userId)
        await postRef.update({
          'likedBy': FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
    }
  }

  void openCommentsPage(String postId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CommentsPage(postId: postId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foodies'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF388E3C)),
              child: Text('Navigation', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: const Text('Leaderboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.health_and_safety),
              title: const Text('Health Tips'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthTipsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Meals Week'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MealsWeekPage()));
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint('Firestore error: ${snapshot.error}');
            return const Center(child: Text('Error fetching posts'));
          }

          final posts = snapshot.data?.docs ?? [];

          if (posts.isEmpty) {
            return ListView.builder(
              itemCount: defaultPosts.length,
              itemBuilder: (context, index) {
                final post = defaultPosts[index];
                return PostCard(
                  postId: post['postId'],
                  postData: post,
                  caption: post['caption'],
                  imageUrl: post['photoUrl'],
                  username: post['username'],
                  likedBy: List<String>.from(post['likedBy']),
                  commentCount: post['commentCount'],
                  onLikeToggle: (_) {},
                  onCommentTap: () {},
                );
              },
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final postDoc = posts[index];
              final postData = postDoc.data() as Map<String, dynamic>;
              final userId = postData['userId'] as String? ?? '';

              // Use FutureBuilder to fetch username asynchronously
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  String username = 'username';
                  if (userSnapshot.hasData && userSnapshot.data!.exists) {
                    final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                    username = userData['username'] ?? '';
                  }

                  final firestoreLikedBy = (postData['likedBy'] as List<dynamic>?) ?? <dynamic>[];
                  final commentCount = postData['commentCount'] ?? 0;
                  final currentUserId = currentUser?.uid ?? '';

                  // Initialize local likedBy for this post if not exists
                  _localLikedByMap.putIfAbsent(
                      postDoc.id, () => List<String>.from(firestoreLikedBy.map((e) => e.toString())));

                  final likedByLocal = _localLikedByMap[postDoc.id]!;

                  // Check if current user liked the post locally
                  final isLiked = likedByLocal.contains(currentUserId);

                  return PostCard(
                    postId: postDoc.id,
                    postData: postData,
                    caption: postData['caption'] ?? '',
                    imageUrl: postData['photoUrl'] ?? '',
                    username: username,
                    likedBy: likedByLocal,
                    commentCount: commentCount,
                    onLikeToggle: (_) async {
                      setState(() {
                        if (isLiked) {
                          likedByLocal.remove(currentUserId);
                        } else {
                          likedByLocal.add(currentUserId);
                        }
                      });
                      await toggleLike(postDoc.id, isLiked);
                    },
                    onCommentTap: () {
                      openCommentsPage(postDoc.id);
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToUploadPostPage,
        backgroundColor: const Color(0xFF388E3C),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
