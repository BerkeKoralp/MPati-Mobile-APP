import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/core/common/navigation_bar.dart';
import 'package:mpati_pet_care/core/common/service_container.dart';
import 'package:mpati_pet_care/core/constants/constants.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/features/home/drawers/settings_drawer.dart';
import 'package:mpati_pet_care/features/home/petcaretaker/petcaretaker_services.dart';
import 'package:mpati_pet_care/models/base_model.dart';
import 'package:mpati_pet_care/models/pet_caretaker_model.dart';
import 'package:mpati_pet_care/models/user_model.dart';
import 'package:mpati_pet_care/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

import '../../../ServiceBoxElements.dart';
import '../../../core/common/session_card.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../models/session_model.dart';
import '../../session/screen/session_screen.dart';

final sessionListCareTakerProvider = StreamProvider.family<List<SessionModel>, String>((ref, userId) async* {
  final stream = ref.read(firestoreProvider).collection('sessions').where('caretakerId', isEqualTo: userId).snapshots();
  await for (final snapshot in stream) {
    yield snapshot.docs.map((doc) => SessionModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
});
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
    final userId = ref.watch(userProvider)!.uid!;
    final sessionsState = ref.watch(sessionListCareTakerProvider(userId));


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
      body:Column(
        children: [
          sessionsState.when(
            data: (sessions) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sessions.length,
              itemBuilder: (_, index) => SessionCard(session: sessions[index]),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Failed to load session: $e')),
          ),
          PetCaretakerServices()
        ],
      )
      ,
        //CARE TAKER SAYFASI SESSİON GÖRÜLSÜN
      bottomNavigationBar:  NavigationBarPet(),
    );
  }
}
//KAAN EKLEDİ
/*
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

// Ensure these imports are correct and the path matches your project structure
import '../../../ServiceBoxElements.dart'; // If ServiceBox definition is here
import 'pet_caretaker_services.dart'; // Assuming this is the correct path for PetCaretakerServices

final sessionListCareTakerProvider = StreamProvider.family<List<SessionModel>, String>((ref, userId) async* {
  final stream = ref.read(firestoreProvider).collection('sessions').where('caretakerId', isEqualTo: userId).snapshots();
  await for (final snapshot in stream) {
    yield snapshot.docs.map((doc) => SessionModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
});

class HomeScreenCareTaker extends ConsumerStatefulWidget {
  const HomeScreenCareTaker({super.key});

  @override
  ConsumerState createState() => _HomeScreenCareTakerState();
}

class _HomeScreenCareTakerState extends ConsumerState<HomeScreenCareTaker> {
  BaseModel? baseModel;

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final PetCareTakerModel? user = ref.watch(userProvider) as PetCareTakerModel;
    final userId = ref.watch(userProvider)!.uid!;
    final sessionsState = ref.watch(sessionListCareTakerProvider(userId));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Palette.nutellaBrown,
        title: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(Constants.logoPath, height: 40),
        ),
        actions: [
          IconButton(
            onPressed: () => Routemaster.of(context).push('/balance-page'),
            icon: const Icon(Icons.account_balance_wallet),
          ),
          IconButton(
            onPressed: () => {}, // Implement functionality or remove if not needed
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user?.profilePic ?? ''),
            ),
          ),
          IconButton(
            onPressed: () => displayEndDrawer(context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      endDrawer: const SettingDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PetCaretakerServices(), // Included custom service widget
            sessionsState.when(
              data: (sessions) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sessions.length,
                itemBuilder: (_, index) => SessionCard(session: sessions[index]),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Failed to load sessions: $e'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavigationBarPet(),
    );
  }
}

 */


