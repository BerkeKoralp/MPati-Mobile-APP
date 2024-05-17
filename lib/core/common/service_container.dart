import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/theme/palette.dart';

class ServiceBox extends ConsumerWidget {
  final double height;
  final double width;
  final VoidCallback? onPressed;
  final String nameOfBox;
  final String iconPath;

  ServiceBox({
    this.onPressed,
    required this.nameOfBox,
    required this.height,
    required this.width,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeOfCurrent = ref.watch(themeNotifierProvider);
    return SizedBox(
      width: width, // Width of the button
      height: height, // Height of the button
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Palette.lightBrown1, Palette.darkBrown1], // Define your gradient colors here
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 2.0),
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7.5),
                    child: Image.asset(
                      iconPath,
                      height: 55,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    nameOfBox,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Acme',
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}