import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:flutter/material.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/theme/palette.dart';
// Assuming this is in a file called provider_setup.dart
final emailControllerProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final passwordControllerProvider = StateProvider<TextEditingController>((ref) => TextEditingController());


class CreateAccountScreen extends ConsumerWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final String selectedValue = ref.watch(typeOfAccountProvider);

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
              autofocus: true,
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
                ref.watch(authControllerProvider.notifier).signUpWithEmailAndPassword(
                    context,
                    email: credentials['email']!,
                    password: credentials['password']!,
                    type: ref.watch(typeOfAccountProvider)
                );

              },
              child: Text('Create Account'),
            ),Column(
        children: <Widget>[
          RadioListTile<String>(
            title: const Text('Owner'),
            value: 'owner',
            groupValue: selectedValue,
            onChanged: (value) {
              ref.read(typeOfAccountProvider.notifier).state = value!;
            },
          ),
          RadioListTile<String>(
            title: const Text('Caretaker'),
            value: 'caretaker',
            groupValue: selectedValue,
            onChanged: (value) {
              ref.read(typeOfAccountProvider.notifier).state = value!;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Selected Value: $selectedValue'),
          ),
        ],
      ),
          ],
        ),
      ),
    );
  }
}