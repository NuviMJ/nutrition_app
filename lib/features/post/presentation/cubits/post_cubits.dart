import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data'; // Added import for Uint8List
import 'package:nutrition_app/features/post/domain/entities/post.dart';
import 'dart:convert'; // Added import for base64Encode
import 'package:nutrition_app/features/post/domain/repo/post_repo.dart';
import 'package:nutrition_app/features/post/presentation/cubits/post_states.dart';
import 'package:nutrition_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:nutrition_app/features/storage/domain/repo/storage_repo.dart'; // Added import for StorageRepo

// class StorageRepo {
//   Future<String> uploadProfileImageMobile(String imagePath, String postId) async {
//     // Add your implementation here
//     return 'uploaded_image_url';
//   }
// }

class PostCubits extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubits({required this.postRepo, required this.storageRepo})
    : super(PostInitial());
  Future<void> createPost(
    Post post, {
    String? imagePath,
    Uint8List? imageBytes,
  }) async {
    String? imageUrl;

    try {
      

      if (imagePath != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadProfileImageMobile(
          imagePath,
          post.id,
        );
      } else if (imageBytes != null) {
        // final base64Image = base64Encode(imageBytes);
        emit(PostUploading());
        imageUrl = await storageRepo.uploadProfileImageWeb(imageBytes, post.id);
      }
      //give image url to post
      final newPost = post.copyWith(imgeUrl: imageUrl);

      //create post in the backend
      postRepo.createPost(newPost);

      //ret-fetchAllPosts
      fetchAllPosts();
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  //fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError('Error fetching posts: $e'));
    }
  }

  //delete post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
      final posts = await postRepo.fetchAllPosts();
    } catch (e) {
      emit(PostError('Error deleting post: $e'));
    }
  }
}
