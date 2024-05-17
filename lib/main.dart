import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/core/providers/firebase_providers.dart';
import 'package:mpati_pet_care/features/authentication/screens/login_screen.dart';
import 'package:mpati_pet_care/features/home/user/home_page.dart';
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
     baseModel =await ref.watch(authControllerProvider.notifier).findUserInRoleCollections(
        data.uid,
        ref.read(typeOfAccountProvider))!.first;
    ref.read(userProvider.notifier).update((state) => baseModel);
    setState(() {
    });
  }
  void getDataUser(WidgetRef ref, User data) async {
    baseModel =await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
    ref.read(userProvider.notifier).update((state) => baseModel);
    setState(() {
    });
  }
   void getDataCaretaker(WidgetRef ref, User data) async {
     baseModel =await ref.watch(authControllerProvider.notifier).getCareTakerData(data.uid).first;
     ref.read(userProvider.notifier).update((state) => baseModel);
     setState(() {
     });
   }

  @override
  Widget build(BuildContext context) {
    final type = ref.watch(typeOfAccountProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(authStateChangeProvider).when(data: (data) =>
        MaterialApp.router(
      title: 'Mpati Demo',
      debugShowCheckedModeBanner: false,
      theme: currentTheme,
      routerDelegate: RoutemasterDelegate(
          routesBuilder: (context) {
            if (data !=null) {
              if(type == 'owner'){
                getDataUser(ref,data);
              }else if(type == 'caretaker')
                {
                  getDataCaretaker(ref, data);
                }else {
                print('Bura geldi');
                }
                 // getData(ref, data);
              if( baseModel != null){
                //type a göre route ata ,screen yani
                      if(baseModel!.type == 'owner'){
                        return loggedInRoute;
                      }
                      else if( baseModel!.type == 'caretaker'){
                    return loggedInRouteCareTaker;
                      }
               // BURADA TYPE A GÖRE ROUTE ATANACAK
              }
              }
            return loggedOutRoute;
          }
      ),
      routeInformationParser: const RoutemasterParser(),
    ),
      error: (error, stackTrace) => ErrorText(error: error.toString()) ,
      loading: () => const Loader(),);
  }

}
