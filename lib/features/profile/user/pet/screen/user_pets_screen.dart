import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../../core/common/pet_card.dart';
import '../../../../../core/providers/firebase_providers.dart';
import '../../../../../models/pet_model.dart';
import '../../../../authentication/controller/auth_controller.dart';


final petsProvider = StreamProvider.family<List<PetModel>, String>((ref, userId) async* {
  final stream = ref.read(firestoreProvider).collection('pets').where('ownerId', isEqualTo: userId).snapshots();
  await for (final snapshot in stream) {
    yield snapshot.docs.map((doc) => PetModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
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
            onPressed: () => Routemaster.of(context).push('/pet-page/pet-add-page'),
          )
        ],
      ),
      body: petsAsyncValue.when(
        data: (pets) => ListView.builder(
          itemCount: pets.length,
          itemBuilder: (_, index) => PetCard(pet: pets[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load pets: $e')),
      ),
    );
  }
}
