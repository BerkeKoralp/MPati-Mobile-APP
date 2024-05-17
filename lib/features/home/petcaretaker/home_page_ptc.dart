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
import 'package:mpati_pet_care/theme/palette.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/common/session_card.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../models/session_model.dart';
import 'caretaker_services.dart';


final sessionListCareTakerProvider = StreamProvider.family<List<SessionModel>, String>((ref, userId) async* {
  final stream = ref.read(firestoreProvider).collection('sessions').where('caretakerId', isEqualTo: userId).snapshots();
  await for (final snapshot in stream) {
    yield snapshot.docs.map((doc) => SessionModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
});
final lastSessionProvider = StreamProvider.family<SessionModel?, String>((ref, userId) {
  // Get the Firestore instance from another provider or directly
  final firestore = ref.read(firestoreProvider);

  // Adjust the query to order by 'createdAt' descending and limit to 1 to get the most recent session
  final stream = firestore.collection('sessions')
      .where('caretakerId', isEqualTo: userId)
      .orderBy('startTime', descending: true)
      .limit(1)
      .snapshots();

  return stream.map((snapshot) {
    // Check if there's at least one document
    if (snapshot.docs.isNotEmpty) {
      return SessionModel.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    }
    return null; // Return null if no sessions found
  });
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
    final sessionAsyncValue = ref.watch(lastSessionProvider(userId));

    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      appBar:AppBar(
        centerTitle: true,
        backgroundColor: Palette.nutellaBrown,
        title: Image.asset(Constants.logoPath,
          height: 40,),
        actions: [
          //balance
          Text(user.balance.toString()),
          Text(user!.mail.toString()),
          IconButton(
              onPressed: () => {
                Routemaster.of(context).push('/balance-page')
              },
              icon:const Icon(Icons.balance)),
          //Profile Snackbar
          IconButton(onPressed: () {
            Routemaster.of(context).push('/edit-profile/${user.uid}');
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
          // sessionsState.when(
          //   data: (sessions) => ListView.builder(
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemCount: sessions.length,
          //     itemBuilder: (_, index) => SessionCard(session: sessions[index]),
          //   ),
          //   loading: () => const Center(child: CircularProgressIndicator()),
          //   error: (e, _) => Center(child: Text('Failed to load session: $e')),
          // ),
          CaretakerServices()
        ]
      )
      ,
        //CARE TAKER SAYFASI SESSİON GÖRÜLSÜN
      bottomNavigationBar:  NavigationBarPet(),
    );
  }
}
