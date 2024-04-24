import 'package:flutter/cupertino.dart';

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
            ServiceBox(nameOfBox: firstBox)
            ,ServiceBox(nameOfBox: secondBox)
          ],
        ),
        Row(children: [
          ServiceBox(nameOfBox: thirdBox)
          ,ServiceBox(nameOfBox: fourthBox)
        ],
        )
      ],
    );
  }
}