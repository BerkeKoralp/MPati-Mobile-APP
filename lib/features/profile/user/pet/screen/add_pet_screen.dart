import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';

import '../../../../../core/providers/firebase_providers.dart';
import '../../../../../models/pet_model.dart';
import '../repository/pet_repository.dart';


final nameControllerProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final breedControllerProvider = StateProvider<TextEditingController>((ref) => TextEditingController());


class PetAddScreen extends ConsumerWidget {


  PetAddScreen({super.key});

  void _addPet(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);
    final pet = PetModel(
        name: ref.watch(nameControllerProvider).text,
        breed: ref.watch(breedControllerProvider).text,
        petId: '', // ID will be generated by Firestore
        age: 2, // Example static data
        profilePic: '',
        vaccine: false,
        weight: 10.0,
        height: 15.0,
        photos: [],
    );
    ref.read(petRepositoryProvider).addPetToUser(user!.uid, pet);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = ref.watch(nameControllerProvider);
    final breedController = ref.watch(breedControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Add New Pet")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Pet Name'),
            ),
            TextField(
              autofocus: true,
              controller: breedController,
              decoration: const InputDecoration(labelText: 'Breed'),
            ),
            ElevatedButton(
              onPressed: () => _addPet(context, ref),
              child: const Text('Add Pet'),
            )
          ],
        ),
      ),
    );
  }


}

final petRepositoryProvider = Provider((ref) => PetRepository( firestore: ref.read(firestoreProvider)));
