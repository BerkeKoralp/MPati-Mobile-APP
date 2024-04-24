//loggedOut

//loggenIn
import 'package:flutter/material.dart';
import 'package:mpati_pet_care/features/authentication/screens/login_screen.dart';
import 'package:mpati_pet_care/features/home/home_page.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
    routes: {
      '/' : (_) => const MaterialPage(child: LoginScreen())
    }
);
final loggedInRoute = RouteMap(
    routes: {
      '/' : (_) => const MaterialPage(child: HomeScreen())
    }
);