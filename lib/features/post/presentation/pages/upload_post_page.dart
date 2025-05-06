import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/features/auth/domain/entities/app_user.dart';
import 'package:nutrition_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:nutrition_app/features/post/domain/entities/post.dart';
import 'package:nutrition_app/features/post/presentation/cubits/post_cubits.dart';
import 'package:nutrition_app/features/post/presentation/cubits/post_states.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  //mobile image pick
  PlatformFile? imagePickedFile;

  Uint8List? webImage;

  //text controller ->caption
  final textController = TextEditingController();

  //cuttrnt user
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  //get current user
  void getCurrentUser() async {
    //get current user from auth provider
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  // pick image
  Future<void> pickImage() async {
    //pick image from gallery
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      //allowMultiple: false,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  //cterate & upload post
  void uploadPost() {
    
    //check if image is picked
    if (imagePickedFile == null || textController.text.isEmpty) {
      //show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please pick an image')));
      return;
    }

    //create a new post
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
    );

    //post cubit
    final postCubit = context.read<PostCubits>();

    //web upload
    if (kIsWeb) {
      postCubit.createPost(
        newPost,
        imagePath: imagePickedFile!.path!,
      );
  }else {
      //mobile upload
      postCubit.createPost(
        newPost,
        imagePath: imagePickedFile!.path!,
      );
    }

    @override
    void dispose() {
      super.dispose();
      textController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubits, PostState>(builder: (context, state){
      if (state is PostLoading || state is PostUploading){
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFF004D00)),
          ),
          
        );
    }

    return buildUploadPage();
    },
    listener: (context, state) {
      if(state is PostLoaded){
        Navigator.pop(context);
      }
    },
    );
  }
 Widget buildUploadPage(){
  return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Post'),
       actions: [
        //upload button
          IconButton(
            onPressed: 
              uploadPost,
            icon: const Icon(Icons.upload),
            
          ),
          
       ],
      ),
      body: Center(
        child:Column(
          children:[
            if(kIsWeb && webImage != null)
            Image.memory(webImage!),

            //image preview for mobile
            if (!kIsWeb && imagePickedFile != null)
              Image.file(
                File(imagePickedFile!.path!),
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),

              //pick image button
              MaterialButton(
                onPressed: pickImage,
                child: const Text('Pick Image'),
              ),

              //caption
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Caption',
                ),
                obscureText: false,
              ),
          ]

        )
      )
    );
 }
}
