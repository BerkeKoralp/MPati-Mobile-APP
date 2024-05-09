import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/theme/palette.dart';

import '../../features/authentication/controller/auth_controller.dart';
import '../constants/constants.dart';
class LoginEmailButton extends ConsumerWidget {
  final String email ;
  final String password;
  const LoginEmailButton(this.email, this.password, {super.key});

  void signInWithEmail(WidgetRef ref,BuildContext context,
      {required String email, required String password,required String type}) {
   print(email);
    print(password);
    ref.read(authControllerProvider.notifier).
    signInWithEmailAndPassword(
        context,
        email: email,
        password: password,
        type: type);
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithEmail(ref, context,
            email: this.email,
            password: this.password,
            type: ref.watch(typeOfAccountProvider)
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.blue,
          minimumSize: const Size(double.infinity, 50),
        ),
        icon: Icon(Icons.login)
        ,
        label: Text(
          "Login",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
