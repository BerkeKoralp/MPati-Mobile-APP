//loggedOut

//loggenIn
import 'package:flutter/material.dart';
import 'package:mpati_pet_care/features/authentication/screens/create_account_screen.dart';
import 'package:mpati_pet_care/features/authentication/screens/login_screen.dart';
import 'package:mpati_pet_care/features/home/home_page.dart';
import 'package:mpati_pet_care/features/home/petcaretaker/home_page_ptc.dart';
import 'package:mpati_pet_care/features/map/repository/map_code.dart';
import 'package:mpati_pet_care/features/profile/user/pet/screen/add_pet_screen.dart';
import 'package:mpati_pet_care/features/profile/user/pet/screen/user_pets_screen.dart';
import 'package:routemaster/routemaster.dart';

import 'features/balance/screen/balance_page.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/map/screen/map_screen.dart';
import 'features/session/screen/session_screen.dart';

final loggedOutRoute = RouteMap(
    routes: {
      '/' : (_) => const MaterialPage(child: LoginScreen()),
      '/create-account' :(_) => MaterialPage(
          child: CreateAccountScreen(
          )
      ),

    }
);
final loggedInRoute = RouteMap(
    routes: {

      '/' : (_) => const MaterialPage(child: HomeScreen()),
      '/map-screen': (_) =>  const MaterialPage(child: MapScreenCustom()),
      '/balance-page' :(_) => const MaterialPage(child: BalancePage())
      ,'/session-create-page' :(_) =>  MaterialPage(child: CareTakingScreen()),
      '/pet-page' :(_) =>  const MaterialPage(child: PetsListScreen()),
      '/pet-page/pet-add-page' :(_) =>  MaterialPage(child: PetAddScreen()),
      '/chat': (_) => MaterialPage(child: ChatScreen()),//chat screene yönlendirmeyi yapamadım
      }
}
);
