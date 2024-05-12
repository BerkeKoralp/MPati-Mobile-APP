import 'dart:convert';

class PetModel {
    final String? name;
    final String? breed;
    final String? petId;
    final int? age;
    final String? ownerId;
    final String? profilePic;
    final bool? vaccine;
    final double? weight;
    final double? height;
    final List<String>? photos;


//<editor-fold desc="Data Methods">
  const PetModel({
    required this.name,
    required this.breed,
    required this.petId,
    required this.age,
    required this.profilePic,
    required this.vaccine,
    required this.weight,
    required this.height,
    required this.photos,
    required this.ownerId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PetModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          breed == other.breed &&
          petId == other.petId &&
          age == other.age &&
          profilePic == other.profilePic &&
          vaccine == other.vaccine &&
          weight == other.weight &&
          height == other.height &&
          photos == other.photos &&
          ownerId == other.ownerId);

  @override
  int get hashCode =>
      name.hashCode ^
      breed.hashCode ^
      petId.hashCode ^
      age.hashCode ^
      profilePic.hashCode ^
      vaccine.hashCode ^
      weight.hashCode ^
      height.hashCode ^
      photos.hashCode ^
      ownerId.hashCode;

  @override
  String toString() {
    return 'Pet{' +
        ' name: $name,' +
        ' breed: $breed,' +
        ' petId: $petId,' +
        ' age: $age,' +
        ' profilePic: $profilePic,' +
        ' vaccine: $vaccine,' +
        ' weight: $weight,' +
        ' height: $height,' +
        ' photos: $photos,' +
        'ownerId: $ownerId,'+
        '}';
  }

  PetModel copyWith({
    String? name,
    String? breed,
    String? petId,
    int? age,
    String? profilePic,
    bool? vaccine,
    double? weight,
    double? height,
    List<String>? photos,
    String? ownerId,
  }) {
    return PetModel(
      name: name ?? this.name,
      breed: breed ?? this.breed,
      petId: petId ?? this.petId,
      age: age ?? this.age,
      profilePic: profilePic ?? this.profilePic,
      vaccine: vaccine ?? this.vaccine,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      photos: photos ?? this.photos,
        ownerId: ownerId ?? this.ownerId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'breed': this.breed,
      'petId': this.petId,
      'age': this.age,
      'profilePic': this.profilePic,
      'vaccine': this.vaccine,
      'weight': this.weight,
      'height': this.height,
      'photos': this.photos,
      'ownerId':this.ownerId,
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      name: map['name'] as String,
      breed: map['breed'] as String,
      petId: map['petId'] as String,
      age: map['age'] as int,
      ownerId: map['ownerId'] as String,
      profilePic: map['profilePic'] as String,
      vaccine: map['vaccine'] as bool,
      weight: (map['weight'] as num).toDouble(),
      height: (map['height'] as num).toDouble(),
      photos: List<String>.from(map['photos'] ?? []),
    );
  }
  String toJson() => json.encode(toMap());

  factory PetModel.fromJson(String source) => PetModel.fromMap(json.decode(source));
}

//</editor-fold>
