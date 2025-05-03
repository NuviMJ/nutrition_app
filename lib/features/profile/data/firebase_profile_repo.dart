import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrition_app/features/profile/domain/entities/profile_user.dart';
import 'package:nutrition_app/features/profile/domain/repo/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          return ProfileUser(
            uid: uid,
            name: userData['name'],
            email: userData['email'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
          );
        }
      }
      return null;
    } catch (e) {
      return null;
      
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedprofile) async {
    try {
      await firebaseFirestore.collection('users').doc(updatedprofile.uid).update({
        'name': updatedprofile.name,
        'bio': updatedprofile.bio,
        'profileImageUrl': updatedprofile.profileImageUrl,
      });
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}


