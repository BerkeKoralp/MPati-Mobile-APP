import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/service_container.dart';

class PetCaretakerServices extends ConsumerWidget {
  const PetCaretakerServices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
          Row(
            children: [
              ServiceBox(
                  nameOfBox: "Pet Owner Location",
                  height: 200,
                  width: 200, 
                  iconPath: 'assets/images/map.png',
                onPressed: () => Routemaster.of(context).push('/map-screen'),
              )
            ],
          )
      ],
    );
  }
}
