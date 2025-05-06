//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/features/profile/domain/repo/profile_repo.dart';
import 'package:nutrition_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:nutrition_app/features/storage/domain/repo/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.profileRepo, required this.storageRepo})
    : super(ProfileInitialState());

  //fethch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoadingState());
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoadedState(user));
      } else {
        emit(ProfileErrorState("User not found"));
      }
    } catch (e) {
      emit(ProfileErrorState("Failed to fetch user profile: $e"));
    }
  }

  //update user profile
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoadingState());

    try {
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileErrorState("User not found"));
        return;
      }

      //profile picture update
      String? imageDownloadUrl;

      //ensure there is an image
      if (imageWebBytes != null || imageMobilePath != null) {
        //upload image to firebase storage
        if (imageMobilePath != null) {
          imageDownloadUrl = await storageRepo.uploadProfileImageMobile(
            imageMobilePath,
            uid,
          );
        } else if (imageWebBytes != null) {
          imageDownloadUrl = await storageRepo.uploadProfileImageWeb(
            imageWebBytes,
            uid,
          );
        }
        if (imageDownloadUrl == null) {
          emit(ProfileErrorState('Failed to upload image'));
          return;
        }
      }

      //update new profile
      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );
      //update profile in repo
      await profileRepo.updateProfile(updatedProfile);

      //re-fetch the updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileErrorState("Failed to update profile: $e"));
    }
  }
}
