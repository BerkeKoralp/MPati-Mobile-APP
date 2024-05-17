import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/features/map/controller/map_controller.dart';
import 'package:routemaster/routemaster.dart';
import 'package:rxdart/transformers.dart';

import 'core/common/service_container.dart';
import 'core/providers/firebase_providers.dart';
import 'core/utils.dart';
import 'features/home/petcaretaker/home_page_ptc.dart';
import 'models/session_model.dart';
final lastSessionProvider = StreamProvider.family<SessionModel?, String>((ref, userId) {
  // Get the Firestore instance from another provider or directly
  final firestore = ref.read(firestoreProvider);

  // Adjust the query to order by 'createdAt' descending and limit to 1 to get the most recent session
  final stream = firestore.collection('sessions')
      .where('userId', isEqualTo: userId)
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

class Services extends ConsumerWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
   final user= ref.watch(userProvider);

    return  const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RequestSessionButton(
              name: "Request Care Taking Service",
              iconPath: "assets/images/explorer.png",
              width: 300,
              height: 135,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MapServiceButton(
              name: "Show Caretakers \nOn Map",
              iconPath: "assets/images/map.png",
              width: 150,
              height: 135,
            ),
            PastBillsButton(
              name: "Show Bills of Past Services",
              iconPath: "assets/images/bills.png",
              width: 300,
              height: 135,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyPetsButton(
              name: "My Pets",
              iconPath: "assets/images/mypets.png",
              width: 150,
              height: 135,
            )
,      ConservationButton(
              name: 'Contact Care Takers',
              iconPath: "assets/images/chats.png",
              width: 150,
              height: 135,
            )
          ],

        ),

      ],
    );
  }
}

class PastBillsButton extends StatelessWidget {
  const PastBillsButton({
    super.key,
    required this.name,
    required this.height,
    required this.width, required this.iconPath,
  });
  final String name;
  final double height;
  final double width;
  final String iconPath ;

  @override
  Widget build(BuildContext context) {
    return ServiceBox(
      nameOfBox: "Show Bills of \nPast Services",
      iconPath: "assets/images/bills.png",
      onPressed: () {},
      width: 150,
      height: 135,
    );
  }
}

class ConservationButton extends ConsumerWidget {
  const ConservationButton({
    super.key,
    required this.name,
    required this.height,
    required this.width,
    required this.iconPath,


  });
  final String name;
  final double height;
  final double width;
  final String iconPath ;

  @override
  Widget build(BuildContext context,WidgetRef ref) {

          return ServiceBox(
            iconPath:iconPath,
            nameOfBox: name,
            onPressed: () {
              Routemaster.of(context).push('/contact-page');
            },
            width: width,
            height: height,
          );
  }
}

class MyPetsButton extends StatelessWidget {
  const MyPetsButton({
    super.key,
    required this.name,
    required this.height,
    required this.width, required this.iconPath,
  });

  final String name;
  final double height;
  final double width;
  final String iconPath ;

  @override
  Widget build(BuildContext context) {
    return ServiceBox(
      iconPath:iconPath,
      nameOfBox: name,
      onPressed: () => Routemaster.of(context).push('/pet-page'),
      height: height,
      width: width,
    );
  }
}

class MapServiceButton extends ConsumerWidget {
  const MapServiceButton(
      {super.key,
        required this.name,
        required this.height,
        required this.width,
        required this.iconPath});
  final String name;
  final double height;
  final double width;
  final String iconPath ;

  void serviceRequest(BuildContext context, WidgetRef ref) {
    ref.watch(mapControllerProvider).determinePositionOfUser(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ServiceBox(
      //Request Service button
      iconPath:iconPath,
      nameOfBox: name,
      onPressed: () => Routemaster.of(context).push('/map-screen'),
      width: width,
      height: height,
    );
  }
}

class RequestSessionButton extends ConsumerWidget {
  const RequestSessionButton(
      {super.key,
        required this.name,
        required this.height,
        required this.width,
        required this.iconPath });
  final String name;
  final double height;
  final double width;
  final String iconPath ;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ServiceBox(
      //Request Service button
      iconPath:iconPath,
      nameOfBox: name,
      onPressed: () => Routemaster.of(context).push('/session-create-page'),
      width: width,
      height: height,
    );
  }
}
