import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/features/auth/data/firebase_auth_repo.dart';
import 'package:nutrition_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:nutrition_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:nutrition_app/features/auth/presentation/pages/login_page.dart';
import 'package:nutrition_app/features/post/presentation/pages/home_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
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
              return const LoginPage();
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
