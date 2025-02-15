import 'package:flutter/material.dart';
import 'package:mpati_pet_care/theme/palette.dart';

class NavigationBarPet extends StatelessWidget {
  const NavigationBarPet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Palette.nutellaBrown,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {},
            icon: const Icon(
              Icons.home_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
          // Adding a vertical divider
          VerticalDivider(
            color: Colors.white,
            width: 2.0,
            thickness: 2.0,
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {},
            icon: const Icon(
              Icons.help_outline,//help outline iyi
              color: Colors.white,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
