import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/features/map/controller/map_controller.dart';
import 'package:routemaster/routemaster.dart';

import 'core/common/service_container.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
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
            ),
            ConservationButton(
              name: 'Chats',
              iconPath: "assets/images/chats.png",
              width: 150,
              height: 135,
            )
          ],
        )
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
      nameOfBox: "Show \nBills of \nPast Services",
      iconPath: "assets/images/bills.png",
      onPressed: () {},
      width: 150,
      height: 135,
    );
  }
}

class ConservationButton extends StatelessWidget {
  const ConservationButton({
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
      onPressed: () {
        Routemaster.of(context).push('/chat-page');
      },
      width: 150,
      height: 135,
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

class ChatButton extends StatelessWidget {
  const ChatButton({
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
  Widget build(BuildContext context) {
    return ServiceBox(
      iconPath:iconPath,
      nameOfBox: name,
      onPressed: () => Routemaster.of(context).push('/chat'),
      height: height,
      width: width,
    );
  }
}