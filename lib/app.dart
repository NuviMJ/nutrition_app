import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/features/auth/data/firebase_auth_repo.dart';
import 'package:nutrition_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:nutrition_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:nutrition_app/features/auth/presentation/pages/auth_page.dart';
import 'package:nutrition_app/features/auth/presentation/pages/login_page.dart';
import 'package:nutrition_app/features/home/presentation/pages/home_page.dart';
import 'package:nutrition_app/features/profile/data/firebase_profile_repo.dart';
import 'package:nutrition_app/features/profile/presentation/cubits/profile_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider( providers: [
      //auth cubit
      BlocProvider<AuthCubit>(
        create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
      ),
      //profile cubit
      BlocProvider<ProfileCubit>(
        create: (context) => ProfileCubit(profileRepo: profileRepo),
      ),
      
      //post cubit
      // BlocProvider<PostCubit>(
      //   create: (context) => PostCubit(postRepo: PostRepo()),
      // ),
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
