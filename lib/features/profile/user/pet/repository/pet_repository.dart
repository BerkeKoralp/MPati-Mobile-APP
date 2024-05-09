
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/firebase_constants.dart';
import '../../../../../models/pet_model.dart';
class PetRepository {
  final FirebaseFirestore _firestore;

  PetRepository( {
    required FirebaseFirestore firestore
}):_firestore = firestore;

  CollectionReference get _pets => _firestore.collection(FirebaseConstants.petsCollection);
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  Future<void> addPetToUser(String? userId, PetModel pet) async {
    DocumentReference petRef = _pets.doc();

    await petRef.set(pet.toMap()); // Create the pet document

    DocumentReference userRef = _users.doc(userId);

    await userRef.update({
      'petIds': FieldValue.arrayUnion([petRef.id]) // Add pet ID to user's pet list
    });
  }
// Implement methods for updating and deleting pets if needed
}