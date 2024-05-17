import 'package:flutter/material.dart';
import 'package:mpati_pet_care/theme/palette.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obsecureText;
  final TextEditingController controller;

  const MyTextField({super.key, required this.controller, required this.hintText, required this.obsecureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: obsecureText,
        controller: controller,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Palette.whiteBrown1),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Palette.whiteBrown1),
            ),
            fillColor: Palette.whiteColor,
            filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),),
      ),
    );
  }
}
