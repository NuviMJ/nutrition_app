//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/features/profile/domain/repo/profile_repo.dart';
import 'package:nutrition_app/features/profile/presentation/cubits/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;

  ProfileCubit({required this.profileRepo}) : super(ProfileInitialState());
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

  Future<void> updateProfile({required String uid, String? newBio}) async {
    emit(ProfileLoadingState());

    try {
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileErrorState("User not found"));
        return;
      }

      //profile picture update

      //update new profile
      final updatedProfile = currentUser.copyWith(newBio: newBio?? currentUser.bio);
      //update profile in repo
      await profileRepo.updateProfile(updatedProfile);

      //re-fetch the updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileErrorState("Failed to update profile: $e"));
    }
  }
}
