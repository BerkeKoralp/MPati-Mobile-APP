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

import '../../../ServiceBoxElements.dart';


class HomeScreenCareTaker extends ConsumerStatefulWidget {
  const HomeScreenCareTaker({super.key});

  @override
  ConsumerState createState() => _HomeScreenCareTakerState();
}

class _HomeScreenCareTakerState extends ConsumerState<HomeScreenCareTaker> {
  BaseModel? baseModel ;
  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }


  @override
  Widget build(BuildContext context ) {
    PetCareTakerModel? user = ref.watch(userProvider) as PetCareTakerModel;

    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      appBar:AppBar(
        centerTitle: true,
        backgroundColor: Palette.nutellaBrown,
        title: Image.asset(Constants.logoPath,
          height: 40,),
        actions: [
          //balance
          Text(user!.balance.toString()),
          Text(user!.mail.toString()),
          IconButton(
              onPressed: () => {
                Routemaster.of(context).push('/balance-page')
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
      body:Scaffold(),
      bottomNavigationBar:  NavigationBarPet(),
    );
  }
}



