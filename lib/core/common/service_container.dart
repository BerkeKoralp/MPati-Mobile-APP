import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/theme/palette.dart';

class ServiceBox extends ConsumerWidget {
  final double height;
  final double width;
   VoidCallback? onPressed;
   final String nameOfBox ;

  // Named constructor that accepts a function
  ServiceBox({ this.onPressed, required this.nameOfBox, required this.height, required this.width});
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final themeOfCurrent = ref.watch(themeNotifierProvider);
    return SizedBox(
      width: width , // Width of the button
      height: height , // Height of the button
      child: ElevatedButton(
        onPressed: onPressed,
        child: Column(
          children: [
            //ICON GELECEK
            Text(nameOfBox,
            style: TextStyle(
              fontSize: 14
            ),),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: themeOfCurrent.cardColor,
          shape: RoundedRectangleBorder( // Adds a border to the button
            borderRadius: BorderRadius.circular(10), // Border radius
            side: BorderSide(color: Colors.white, width: 2.0), // Border width and color
          ),// Text color
        ),
      ),
    );
  }
}
