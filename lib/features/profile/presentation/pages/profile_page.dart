import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/features/auth/domain/entities/app_user.dart';
import 'package:nutrition_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:nutrition_app/features/profile/presentation/components/bio_box.dart';
import 'package:nutrition_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:nutrition_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:nutrition_app/features/profile/presentation/pages/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  //current user
  late AppUser? currentUser = authCubit.currentUser;

  //on start
  @override
  void initState() {
    super.initState();
    //fetch user profile
    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        //loaded
        if (state is ProfileLoadedState) {
          //get loaded user
          final user = state.profileUser;

          return Scaffold(appBar: AppBar(title: Text(user.name),
          ),
            body: Center(
              child: Column(
                children: [
                  //user image
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 4),
                          image: DecorationImage(
                            image: NetworkImage("profileImageUrl"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                  const SizedBox(height: 20),

                  //user name
                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  //user bio
                  Text(
                    user.bio,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  // BioBox(text: user.bio),

                  const SizedBox(height: 20),
                 
                  // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004D00),
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text('Like'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>  EditProfilePage(user: user,),
                          )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          child: const Text('Edit Profile'),
                        ),
                      ),
                    ],
                  ),
                ),
                ],
              ),
            ),
          );
        }
        //loading state
        else if (state is ProfileLoadingState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF004D00)),
              ),
            ),
          );
        } 
        // fallback state
        else {
          return const Scaffold(
            body: Center(child: Text("An error occurred or no data available.")),
          );
        }
      },
    );
  }
}
