import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/features/map/controller/map_controller.dart';
import 'package:routemaster/routemaster.dart';

import 'core/common/service_container.dart';

class Services extends StatelessWidget {

  const Services({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        const Row(
          children: [
            RequestSessionButton(
      name:"Request Care Taking Service",
      width: 300,
      height: 135, )
          ],
        ),
        Row(
    children: [
         const MapServiceButton(
          name: "Show Caretakers \nOn Map",
          width: 150,
          height: 135,
          ),
          ServiceBox(
          nameOfBox: "Show \nBills of \nPast Services",
            onPressed: () {
          },
          width: 150,
          height: 135,
    ),

        ],
        ),
        Row(
          children: [
          const MyPetsButton(
          name: "My Pets",
          width: 150,
          height: 135,
    )
          ,ServiceBox(nameOfBox: "Feature 6",
            onPressed: () {

            },
          width:150,
          height: 135,
          )
        ],)

      ],
    );
  }
}

class MyPetsButton extends StatelessWidget {
  const MyPetsButton({
    super.key,
    required this.name, required this.height, required this.width,
  });

  final String name;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ServiceBox(nameOfBox: name,
        onPressed: () =>  Routemaster.of(context).push('/pet-page'),height: height,width: width,
    );
  }
}

class MapServiceButton extends ConsumerWidget {
  const MapServiceButton({
    super.key,
    required this.name,
    required this.height,
    required this.width
  });
  final String name;
  final double height;
  final double width;

  void serviceRequest(BuildContext context, WidgetRef ref){
    ref.watch(mapControllerProvider).determinePositionOfUser(context);
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return ServiceBox(
      //Request Service button
        nameOfBox: name,
        onPressed: () =>  Routemaster.of(context).push('/map-screen'),
        width: width,
    height: height,);
  }
}

class RequestSessionButton extends ConsumerWidget {
  const RequestSessionButton({
    super.key,
    required this.name,
    required this.height,required this.width
  });
  final String name;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return ServiceBox(
      //Request Service button
        nameOfBox: name,
        onPressed: () =>  Routemaster.of(context).push('/session-create-page')
      ,width: width,
      height: height,);
  }
}
class ChatButton extends StatelessWidget {
  const ChatButton({
    super.key,
    required this.sixthbox,
  });

  final String sixthbox;

  @override
  Widget build(BuildContext context) {
    return ServiceBox(nameOfBox: sixthbox,
        onPressed: () =>  Routemaster.of(context).push('/chat')
    );
  }
}