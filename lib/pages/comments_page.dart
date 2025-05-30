import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentsPage extends StatefulWidget {
  final String postId;

  const CommentsPage({super.key, required this.postId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _postComment() async {
    final String text = _commentController.text.trim();
    if (text.isEmpty) {
      return;
    }

    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to comment.')),
      );
      return;
    }

    try {
      // Fetch user's display name from 'users' collection
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_currentUser.uid)
              .get();

      String displayName = _currentUser.email!; // Default to email
      if (userDoc.exists && userDoc.data() != null) {
        displayName =
            (userDoc.data() as Map<String, dynamic>)['displayName'] ??
            _currentUser.email!;
      }

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add({
            'text': text,
            'userId': _currentUser.uid,
            'userDisplayName': displayName, // Using displayName
            'timestamp': FieldValue.serverTimestamp(),
          });

      // Increment commentCount on the post
      // This is a client-side increment. For more robust counting, use Firebase Functions.
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .update({'commentCount': FieldValue.increment(1)});

      _commentController.clear();
    } catch (e) {
      print('Error posting comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post comment: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.postId)
                      .collection('comments')
                      .orderBy('timestamp', descending: false)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No comments yet.'));
                }

                final comments = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment =
                        comments[index].data() as Map<String, dynamic>;
                    final String text = comment['text'] as String? ?? '';
                    final String userDisplayName =
                        comment['userDisplayName'] as String? ?? 'Anonymous';
                    // final Timestamp timestamp = comment['timestamp'] as Timestamp? ?? Timestamp.now();
                    // String formattedDate = DateFormat('MMM d, yyyy - hh:mm a').format(timestamp.toDate());

                    return ListTile(
                      title: Text(text),
                      subtitle: Text('By: $userDisplayName'),
                      // trailing: Text(formattedDate),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Write a comment...',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _postComment(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _postComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
