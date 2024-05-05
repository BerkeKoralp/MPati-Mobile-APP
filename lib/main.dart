import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/features/authentication/screens/login_screen.dart';
import 'package:mpati_pet_care/features/home/home_page.dart';
import 'package:mpati_pet_care/models/base_model.dart';
import 'package:mpati_pet_care/router.dart';
import 'package:mpati_pet_care/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

import 'core/common/error_text.dart';
import 'core/common/loader.dart';
import 'features/authentication/controller/auth_controller.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  BaseModel? baseModel;

  void getData (WidgetRef ref ,User data) async{
    baseModel =await ref.watch(authControllerProvider.notifier).findUserInRoleCollections(data.uid)!.first;

    ref.read(userProvider.notifier).update((state) => baseModel);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(data: (data) =>
        MaterialApp.router(
      title: 'Mpati Demo',
      debugShowCheckedModeBanner: false,
      routerDelegate: RoutemasterDelegate(
          routesBuilder: (context) {
            if (data !=null){
                getData(ref, data);
              if(baseModel != null){
                  return loggedInRoute;
              }
            }
            return loggedOutRoute;
          }
      ),
      routeInformationParser: RoutemasterParser(),
    ),
      error: (error, stackTrace) => ErrorText(error: error.toString()) ,
      loading: () => const Loader(),);
  }

}
