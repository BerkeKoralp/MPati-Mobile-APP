import 'package:mpati_pet_care/models/pet_model.dart';
import 'package:mpati_pet_care/models/user_model.dart';

class PetOwnerModel extends UserModel {
  final List<Pet> pets;
  // Constructor chaining to initialize superclass
   PetOwnerModel({
    required this.pets,
    required String name,
    required String profilePic,
    required String uid,
    required int balance,
    required bool isAuthenticated,
    required String address,
    required String type,
  }) : super(
    // Initialize superclass fields
    name: name,
    profilePic: profilePic,
    uid: uid,
    balance: balance,
    isAuthenticated: isAuthenticated,
    address: address,
    type: type,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is PetOwnerModel &&
              runtimeType == other.runtimeType &&
              pets == other.pets);

  @override
  int get hashCode => pets.hashCode;

  @override
  String toString() {
    return 'PetOwnerModel{' + ' pets: $pets,' + '}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(), // Include superclass fields
      'pets': pets.map((pet) => pet.toMap()).toList(),
    };
  }

  factory PetOwnerModel.fromMap(Map<String, dynamic> map) {
    return PetOwnerModel(
      pets: (map['pets'] as List<dynamic>)
          .map((petMap) => Pet.fromMap(petMap as Map<String, dynamic>))
          .toList(),
      // Extract superclass fields
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      uid: map['uid'] as String,
      balance: map['balance'] ?? 0,
      isAuthenticated: map['isAuthenticated'] as bool,
      address: map['address'] as String,
      type: map['type'] as String,
    );
  }
}
