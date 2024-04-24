import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/core/common/navigation_bar.dart';
import 'package:mpati_pet_care/core/common/service_container.dart';
import 'package:mpati_pet_care/core/constants/constants.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/features/home/drawers/settings_drawer.dart';
import 'package:mpati_pet_care/theme/palette.dart';

import '../../ServiceBoxElements.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }
  @override
  Widget build(BuildContext context ) {
    final user = ref.watch(userProvider)!;

    return Scaffold(endDrawerEnableOpenDragGesture: false,
      appBar:AppBar(
        centerTitle: true,
        backgroundColor: Palette.nutellaBrown,
        title: Image.asset(Constants.logoPath,
          height: 40,),
        actions: [
          //balance
          Text(user.name.toString()),
          Text(user.balance.toString()),
          IconButton(
              onPressed: () => {

              },
              icon:const Icon(Icons.balance)),
          //Profile Snackbar
          IconButton(onPressed: () {

          },
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic.toString() ),
            ),
          ),
          //Settings
          Builder(builder: (context) {
            return IconButton(
                onPressed: () => displayEndDrawer(context)
                ,
                icon:const Icon(Icons.settings));
          },
          ),


        ],

      ),
      endDrawer: const SettingDrawer(),
      body:
      SingleChildScrollView(
        //Main Column Elements
        child: Column(
          children: [
            Services(
                firstBox: "Request Service",secondBox: "Previous Service",
                thirdBox: "Explore Caretakers",fourthBox: "Bills"
            ),

          ],
        ),
      ),
      bottomNavigationBar:  NavigationBarPet(),
    );
  }
}


