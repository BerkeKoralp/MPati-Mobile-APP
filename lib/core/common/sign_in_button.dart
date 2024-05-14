import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/theme/palette.dart';

import '../../features/authentication/controller/auth_controller.dart';
import '../constants/constants.dart';
class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref){
    ref.watch(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: () =>signInWithGoogle(context,ref) ,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Palette.nutellaBrown,
          minimumSize: const Size(double.infinity, 50),
        ),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        label: Text(
          "Continiue with Google",
          style: TextStyle(
            fontSize: 18,
              fontFamily: 'Acme'
          ),
        ),
      ),
    );
  }
}
