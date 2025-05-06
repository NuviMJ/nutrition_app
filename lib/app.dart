import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/features/auth/data/firebase_auth_repo.dart';
import 'package:nutrition_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:nutrition_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:nutrition_app/features/auth/presentation/pages/auth_page.dart';
import 'package:nutrition_app/features/auth/presentation/pages/login_page.dart';
import 'package:nutrition_app/features/home/presentation/pages/home_page.dart';
import 'package:nutrition_app/features/post/data/firebase_post_repo.dart';
import 'package:nutrition_app/features/post/presentation/cubits/post_cubits.dart';
import 'package:nutrition_app/features/profile/data/firebase_profile_repo.dart';
import 'package:nutrition_app/features/storage/data/firebase_storage_repo.dart'; // Ensure this path is correct
import 'package:nutrition_app/features/post/presentation/cubits/post_cubits.dart'; // Ensure this path is correct
import 'package:nutrition_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:nutrition_app/features/storage/data/firebase_storage_repo.dart';
import 'package:nutrition_app/themes/light_mode.dart';

/*
App - Root level

-------------------------------------
Repositories: for the database
  -firebase

Bloc providers: for state managment
  -auth
  -profile
  -post
  -search
  -theme

Check auth state
  -unauthenticated -> login page
  -authenticated -> home page   
*/

class MyApp extends StatelessWidget {
  //auth repositary
  final authRepo = FirebaseAuthRepo();
  MyApp({super.key});

  //profile repositary
  final profileRepo = FirebaseProfileRepo();

  //storage repository
  final firebaseStorageRepo = FirebaseStorageRepo();
  
  //post repositary
  final firebasePostRepo = FirebasePostRepo();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider( providers: [

      //auth cubit
      BlocProvider<AuthCubit>(
        create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
      ),

      //profile cubit
      BlocProvider<ProfileCubit>(
        //create: (context) => ProfileCubit(profileRepo: profileRepo),
        create: (context) => ProfileCubit(
          profileRepo: profileRepo,
          storageRepo: firebaseStorageRepo,
        ),
          
      ),
      
      //post cubit
      BlocProvider<PostCubits>(
        create: (context) => PostCubits(
          postRepo: firebasePostRepo,
          storageRepo: firebaseStorageRepo,
        ),
      ),
    ],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        //home:LoginPage(),
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);
             if (authState is Authenticated) {
              return const HomePage();
            }
            if (authState is Unauthenticated) {
              return const AuthPage();
            }
            else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
          listener: ( context, AuthState state) {
            if(state is AuthError){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
