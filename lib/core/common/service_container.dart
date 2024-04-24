import 'package:flutter/material.dart';
import 'package:mpati_pet_care/theme/palette.dart';

class ServiceBox extends StatelessWidget {
  final String nameOfBox;
  final Function? onTap;
  const ServiceBox({super.key, required this.nameOfBox, this.onTap});

  @override
  Widget build(BuildContext context) {
 return  Padding(
   padding: const EdgeInsets.only(left: 15,right: 15,top: 30,bottom: 30),
   child: GestureDetector(
     onTap: () => onTap,
     child: Container(
       width: 150.0,
       height: 200.0,

       padding: EdgeInsets.all(10.0),
       decoration: BoxDecoration(
         color: Palette.whiteBrown1,
         borderRadius: BorderRadius.circular(10.0),
         boxShadow: [
           BoxShadow(
             color: Palette.darkBrown1,
             offset: Offset(4, 4),
             blurRadius: 10,
           ),
         ],
       ),
       alignment: Alignment.center,
       child: Text(
         nameOfBox,
         style: TextStyle(
             color: Palette.nutellaBrown,
             fontSize: 25,
             fontWeight: FontWeight.bold),
       ),
     ),
   ),
 );
  }
}
