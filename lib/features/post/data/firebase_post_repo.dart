import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrition_app/features/post/domain/entities/post.dart';
import 'package:nutrition_app/features/post/domain/repo/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //strore the posts in collection 'Posts'
  final CollectionReference postsCollection = FirebaseFirestore.instance
      .collection('posts');
  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await postsCollection.doc(postId).delete();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      //get all post with most recent post first
      final postSnapshot =
          await postsCollection.orderBy('timestamp', descending: true).get();

      //convert each firestore document from json ->list of posts
      final List<Post> allPosts =
          postSnapshot.docs
              .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

      return allPosts;
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  @override
  Future<List<Post>> fetchpostByUserId(String userId) async {
    try {
      //fetch posts snapshot by userId
      final postSnapshot =
          await postsCollection.where('userId', isEqualTo: userId).get();

      //convert each firestore document from json ->list of posts
      final userPosts =
          postSnapshot.docs
              .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

      return userPosts;
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }
}
