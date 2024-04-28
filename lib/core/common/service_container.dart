import 'package:flutter/material.dart';
import 'package:mpati_pet_care/theme/palette.dart';

class ServiceBox extends StatelessWidget {
   VoidCallback? onPressed;
   final String nameOfBox ;
  // Named constructor that accepts a function
  ServiceBox({ this.onPressed, required this.nameOfBox});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0, // Width of the button
      height: 200.0, // Height of the button
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(nameOfBox,
        style: TextStyle(
          fontSize: 24
        ),),
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.darkBrown1,
          shape: RoundedRectangleBorder( // Adds a border to the button
            borderRadius: BorderRadius.circular(10), // Border radius
            side: BorderSide(color: Colors.white, width: 2.0), // Border width and color
          ),// Text color
        ),
      ),
    );
  }
}
