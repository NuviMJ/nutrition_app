import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:nutrition_app/features/home/presentation/component/my_drawer_tile.dart';
import 'package:nutrition_app/features/profile/presentation/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              //logo
              // const CircleAvatar(
              //   radius: 50,
              //   backgroundImage: AssetImage('assets/images/logo.png'),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.person, size: 100, color: Colors.grey[700]),
              ),

              const SizedBox(height: 20),

              //divider line
              const Divider(color: Colors.grey, thickness: 1),

              //name
              const Text(
                'Your Nutrition App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              //HOME TILE
              MyDrawerTile(
                title: "HOME",
                icon: Icons.home,
                onTap: () => Navigator.of(context).pop(),
              ),

              MyDrawerTile(
                title: "HEALTH TIPS",
                icon: Icons.health_and_safety_rounded,
                onTap: () {},
              ),

              MyDrawerTile(
                title: "MEAL OF THE WEEK",
                icon: Icons.restaurant_menu,
                onTap: () {},
              ),

              MyDrawerTile(
                title: "PROFILE",
                icon: Icons.person,
                onTap: () {
                  //pop menu drawer
                  Navigator.of(context).pop();
                  //get current user uid
                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;
                  //navigate to profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: uid),
                    ),
                  );
                },
              ),

              MyDrawerTile(
                title: "SETTING",
                icon: Icons.settings,
                onTap: () {},
              ),

              //SEARCH TILE
              MyDrawerTile(title: "SEARCH", icon: Icons.search, onTap: () {}),

              const Spacer(),

              //logout tile
              MyDrawerTile(
                title: "LOGOUT",
                icon: Icons.login,
                onTap: () => context.read<AuthCubit>().logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
