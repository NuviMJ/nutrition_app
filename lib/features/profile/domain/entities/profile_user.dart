import 'package:nutrition_app/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;
  // final String? phoneNumber;
  // final String? address;
  // final String? imageUrl;

  ProfileUser({
    required super.uid,
    required super.name,
    required super.email,
    required this.bio,
    required this.profileImageUrl,
  });

//method to update user profile
  ProfileUser copyWith({
    String? newBio,
    String? newProfileImageUrl,
  }) {
    return ProfileUser(
      uid: uid,
      name: name,
      email: email,
      bio: newBio ?? this.bio,
      profileImageUrl: newProfileImageUrl ?? this.profileImageUrl,
    );
  }

//convert profile user to json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
    };
  }
  //covert json to profile user
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'] ?? "",
      profileImageUrl: json['profileImageUrl'] ?? "",
    );
  }
}
