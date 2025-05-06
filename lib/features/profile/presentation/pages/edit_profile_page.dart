import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
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
  PlatformFile? imagePickedFile;
  Uint8List? webImage;
  final bioTextController = TextEditingController();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    bioTextController.text = widget.user.bio ?? '';
  }

  Future<void> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: kIsWeb,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          imagePickedFile = result.files.first;
          if (kIsWeb) {
            webImage = imagePickedFile!.bytes;
          }
        });
        // Immediately upload the image when picked
        await updateProfile(imageOnly: true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> updateProfile({bool imageOnly = false}) async {
    if (_isUpdating) return;

    setState(() => _isUpdating = true);

    try {
      final profileCubit = context.read<ProfileCubit>();
      final String uid = widget.user.uid;
      final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
      final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;
      final String? newBio = imageOnly ? null : 
          (bioTextController.text.trim().isNotEmpty 
              ? bioTextController.text.trim() 
              : null);

      if (imagePickedFile != null || newBio != null) {
        await profileCubit.updateProfile(
          uid: uid,
          newBio: newBio,
          imageWebBytes: imageWebBytes,
          imageMobilePath: imageMobilePath,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(imageOnly 
                  ? 'Profile image updated successfully!' 
                  : 'Profile updated successfully!'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
      
      // Only navigate back if this was a full update (not image-only)
      if (!imageOnly && mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        return buildEditPage();
      },
      listener: (context, state) {
        if (state is ProfileErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
    );
  }

  Widget buildEditPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          if (_isUpdating)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(color: Color(0xFF004D00)),
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // User image with edit button
            GestureDetector(
              onTap: pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 4),
                    ),
                    child: ClipOval(
                      child: _buildImageWidget(),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.edit, size: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bio text field
            TextField(
              controller: bioTextController,
              maxLines: 3,
              maxLength: 150,
              decoration: const InputDecoration(
                hintText: "Tell us about yourself...",
                border: OutlineInputBorder(),
                labelText: "Bio",
              ),
            ),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUpdating ? null : () => updateProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004D00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (!kIsWeb && imagePickedFile != null) {
      return Image.file(File(imagePickedFile!.path!), fit: BoxFit.cover);
    } else if (kIsWeb && webImage != null) {
      return Image.memory(webImage!, fit: BoxFit.cover);
    }
    return CachedNetworkImage(
      imageUrl: widget.user.profileImageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => const CircularProgressIndicator(color: Color(0xFF004D00)),
      errorWidget: (context, url, error) => const Icon(Icons.person),
    );
  }
}