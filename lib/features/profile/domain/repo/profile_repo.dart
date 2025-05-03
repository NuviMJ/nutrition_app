import 'package:nutrition_app/features/profile/domain/entities/profile_user.dart';

// profile repo

abstract class ProfileRepo {
  
  Future<ProfileUser?> fetchUserProfile(String uid);

  Future<void> updateProfile(ProfileUser updatedprofile);
}