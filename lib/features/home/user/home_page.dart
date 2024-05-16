import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/core/common/navigation_bar.dart';
import 'package:mpati_pet_care/core/common/service_container.dart';
import 'package:mpati_pet_care/core/constants/constants.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/features/home/drawers/settings_drawer.dart';
import 'package:mpati_pet_care/models/base_model.dart';
import 'package:mpati_pet_care/models/pet_caretaker_model.dart';
import 'package:mpati_pet_care/models/user_model.dart';
import 'package:mpati_pet_care/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../../models/session_model.dart';
import '../../../services_pet_owner.dart';
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  BaseModel? baseModel;

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider) as UserModel;
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/mpati_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(user.name!),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Sets a moderate rounding effect
                child: Image.asset(
                  Constants.logoPath,
                  height: 45, // Specifies the height of the image
                ),
              ),
              actions: [
                // Balance
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${user.balance} \$",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Routemaster.of(context).push('/balance-page');
                  },
                  icon: const Icon(Icons.balance),
                ),
                // Profile Snackbar
                IconButton(
                  onPressed: () {
                    navigateToUserProfile(context, user.uid!);
                  },
                  icon: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePic.toString()),
                  ),
                ),
                // Settings
                Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () => displayEndDrawer(context),
                      icon: const Icon(Icons.settings),
                    );
                  },
                ),
              ],
            ),
            endDrawer: const SettingDrawer(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(45.0),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Services(),
                    // Other things can be put here
                  ],
                ),
              ),
            ),
            bottomNavigationBar: NavigationBarPet(),
          ),
        ],
      ),
    );
  }
}