import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/features/profile/domain/entities/profile_user.dart';
import 'package:nutrition_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:nutrition_app/features/profile/presentation/cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioTextController = TextEditingController();

  //update profile button pressed

  void updateProfile() async{
    //profile cubit
    final profileCubit = context.read<ProfileCubit>();

    if ( bioTextController.text.isNotEmpty) {
      //update profile
      await profileCubit.updateProfile(
        uid: widget.user.uid,
        newBio: bioTextController.text,
      );
    } else {
      //show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bio cannot be empty")),
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        //profile loading
        if (state is ProfileLoadingState) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text("Loading...",style: TextStyle(color: Colors.black),),
              ],
            ),
          );
        }
        //profilr error

        //edit form
        return buildEditPage();
      },
      listener: (context, state) {},
    );
  }

  Widget buildEditPage({double uploadProgress = 0.0}) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),

      body: Column(
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
                    image: NetworkImage(widget.user.profileImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
            ],
          ),
          const SizedBox(height: 16),
          //bio text field
          TextField(
            controller: bioTextController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Bio",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          //save button
          ElevatedButton(
            onPressed: updateProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004D00),
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
