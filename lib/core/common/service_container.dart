import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/theme/palette.dart';

class ServiceBox extends ConsumerWidget {
  final double height;
  final double width;
   VoidCallback? onPressed;
   final String nameOfBox ;
  final String iconPath ;


  // Named constructor that accepts a function
  ServiceBox( { this.onPressed, required this.nameOfBox,
    required this.height, required this.width, required this.iconPath});
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final themeOfCurrent = ref.watch(themeNotifierProvider);
    return SizedBox(
      width: width , // Width of the button
      height: height , // Height of the button
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7.5), // This value is half the height to make it fully rounded
                child: Image.asset(
                  iconPath,
                  height: 55,
                ),
              ),
              //ICON GELECEK
              SizedBox(height: 8,),
              Text(nameOfBox,
                textAlign: TextAlign.center,
              style: TextStyle(

                fontSize: 15
              ),),
            ],
          ),
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
