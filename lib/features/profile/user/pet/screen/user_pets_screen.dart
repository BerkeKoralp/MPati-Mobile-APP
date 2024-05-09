import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/core/providers/firebase_providers.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/models/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../../core/common/pet_card.dart';

final petsProvider = FutureProvider.family<List<PetModel>, String>((ref, userId) async {
  QuerySnapshot snapshot = await ref.read(firestoreProvider)
      .collection('pets')
      .where('ownerId', isEqualTo: userId)
      .get();

  return snapshot.docs.map((doc) => PetModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
});

class PetsListScreen extends ConsumerWidget {
  const PetsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userProvider)!.uid;
    final petsAsyncValue = ref.watch(petsProvider(userId!));

    return Scaffold(
      appBar: AppBar(
        title: Text("My Pets"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to add pet screen
              Routemaster.of(context).push('/pet-page/pet-add-page');
            },
          )
        ],
      ),
      body: petsAsyncValue.when(
        data: (pets) => ListView.builder(
          itemCount: pets.length,
          itemBuilder: (_, index) => PetCard(pet: pets[index]),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load pets')),
      ),
    );
  }
}
