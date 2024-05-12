import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../../core/providers/firebase_providers.dart';
import '../../../../../models/pet_model.dart';
import '../../../../authentication/controller/auth_controller.dart';
import '../repository/pet_repository.dart';

final nameControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final breedControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final ageControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final weightControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final heightControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final profilePicProvider = StateProvider.autoDispose<File?>((ref) => null);

class PetAddScreen extends ConsumerWidget {
  PetAddScreen({super.key});

  Future<String> uploadImage(File imageFile,WidgetRef ref) async {
    try {
      // Create a unique file name for the image
      String fileName = 'profile_pics/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';

      // Get a reference to the Firebase Storage bucket
      final storage =ref.read(storageProvider)  ;

      // Create a reference to the file location
      Reference referenceOfLocation = storage.ref().child(fileName);

      // Upload the file to Firebase Storage
      UploadTask uploadTask = referenceOfLocation.putFile(imageFile);

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Retrieve the URL of the uploaded image
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }
  Future<void> _pickImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ref.read(profilePicProvider.notifier).update((state) =>  File(pickedFile.path)) ;
    }
  }

  Future<void> _addPet(BuildContext context, WidgetRef ref) async {
    final user = ref.read(userProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: No user found!')),
      );
      return;
    }

    final profilePicFile = ref.read(profilePicProvider);
    String profilePicUrl = '';
    if (profilePicFile != null) {
      profilePicUrl = await uploadImage(profilePicFile,ref);
    }

    final pet = PetModel(
      name: ref.read(nameControllerProvider).text,
      breed: ref.read(breedControllerProvider).text,
      petId: '',
      age: int.tryParse(ref.read(ageControllerProvider).text) ?? 0,
      ownerId: user.uid,
      profilePic: profilePicUrl,
      vaccine: false,
      weight: double.tryParse(ref.read(weightControllerProvider).text) ?? 0.0,
      height: double.tryParse(ref.read(heightControllerProvider).text) ?? 0.0,
      photos: [],
    );

    await ref.read(petRepositoryProvider).addPetToUser(user.uid, pet);
    Routemaster.of(context).pop();
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = ref.watch(nameControllerProvider);
    final breedController = ref.watch(breedControllerProvider);
    final ageController = ref.watch(ageControllerProvider);
    final heightController = ref.watch(heightControllerProvider);
    final weightController = ref.watch(weightControllerProvider);
    final profilePic = ref.watch(profilePicProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Add New Pet")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (profilePic != null)
              Image.file(profilePic, width: 100, height: 100),
            ElevatedButton(
              onPressed: () => _pickImage(ref),
              child: const Text('Pick Profile Picture'),
            ),
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
            TextField(
              autofocus: true,
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            TextField(
              autofocus: true,
              controller: heightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
              decoration: const InputDecoration(labelText: 'Height'),
            ),
            TextField(
              autofocus: true,
              controller: weightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
              decoration: const InputDecoration(labelText: 'Weight'),
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




final petRepositoryProvider = Provider.autoDispose((ref) => PetRepository(firestore: ref.read(firestoreProvider)));
