import 'package:nutrition_app/features/profile/domain/entities/profile_user.dart';

abstract class ProfileStates {}

//initial state
class ProfileInitialState extends ProfileStates {}

//loading state
class ProfileLoadingState extends ProfileStates {}

//loaded state
class ProfileLoadedState extends ProfileStates {
  final ProfileUser profileUser;
  ProfileLoadedState(this.profileUser);
}

//error state
class ProfileErrorState extends ProfileStates {
  final String errorMessage;
  ProfileErrorState(this.errorMessage);
}
