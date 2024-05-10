import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/features/map/controller/map_controller.dart';
import 'package:routemaster/routemaster.dart';

import 'core/common/service_container.dart';

class Services extends StatelessWidget {
  final String firstBox;
  final String secondBox;
  final String thirdBox;
  final String fourthBox;
  final String fifthBox;
  final String sixthBox;

  const Services({
    super.key, required this.firstBox, required this.secondBox, required this.thirdBox, required this.fourthBox, required this.fifthBox, required this.sixthBox,
  });

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Row(
          children: [
            MapServiceButton(firstBox: firstBox),
            ServiceBox(nameOfBox: secondBox,onPressed: () {

            },)
          ],
        ),
        Row(children: [
          RequestSessionButton(thirdBox:thirdBox )
          ,ServiceBox(nameOfBox: fourthBox,
            onPressed: () {

          },
          )
        ],
        ),
        Row(children: [
          MyPetsButton(fifthBox: fifthBox)
          ,ServiceBox(nameOfBox: sixthBox,
            onPressed: () {

            },
          )
        ],)

      ],
    );
  }
}

class MyPetsButton extends StatelessWidget {
  const MyPetsButton({
    super.key,
    required this.fifthBox,
  });

  final String fifthBox;

  @override
  Widget build(BuildContext context) {
    return ServiceBox(nameOfBox: fifthBox,
        onPressed: () =>  Routemaster.of(context).push('/pet-page')
    );
  }
}

class MapServiceButton extends ConsumerWidget {
  const MapServiceButton({
    super.key,
    required this.firstBox,
  });

  final String firstBox;
  void serviceRequest(BuildContext context, WidgetRef ref){
    ref.watch(mapControllerProvider).determinePositionOfUser(context);
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return ServiceBox(
      //Request Service button
        nameOfBox: firstBox,
        onPressed: () =>  Routemaster.of(context).push('/map-screen'));
  }
}

class RequestSessionButton extends ConsumerWidget {
  const RequestSessionButton({
    super.key,
    required this.thirdBox,
  });

  final String thirdBox;
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return ServiceBox(
      //Request Service button
        nameOfBox: thirdBox,
        onPressed: () =>  Routemaster.of(context).push('/session-create-page'));
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