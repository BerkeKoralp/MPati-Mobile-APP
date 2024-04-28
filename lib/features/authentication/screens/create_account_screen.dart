import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:flutter/material.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/theme/palette.dart';
class CreateAccountScreen extends ConsumerWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.nutellaBrown,
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                final credentials = {
                  'email': emailController.text,
                  'password': passwordController.text
                };
                ref.read(authControllerProvider.notifier).signUpWithEmailAndPassword(
                    context,
                    email: credentials['email']!,
                    password: credentials['password']!
                );

              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}