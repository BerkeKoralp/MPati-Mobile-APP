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


  const Services({
    super.key, required this.firstBox, required this.secondBox, required this.thirdBox, required this.fourthBox,
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
          ServiceBox(nameOfBox: thirdBox,onPressed: () {

          },)
          ,ServiceBox(nameOfBox: fourthBox,onPressed: () {

          },)
        ],
        )
      ],
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