import 'dart:convert';

class Pet {
    final String name;
    final String type;
    final int age;
    final String profilePic;
    final bool vaccine;
    final double weight;
    final double height;

//<editor-fold desc="Data Methods">
  const Pet({
    required this.name,
    required this.type,
    required this.age,
    required this.profilePic,
    required this.vaccine,
    required this.weight,
    required this.height,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pet &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type &&
          age == other.age &&
          profilePic == other.profilePic &&
          vaccine == other.vaccine &&
          weight == other.weight &&
          height == other.height);

  @override
  int get hashCode =>
      name.hashCode ^
      type.hashCode ^
      age.hashCode ^
      profilePic.hashCode ^
      vaccine.hashCode ^
      weight.hashCode ^
      height.hashCode;

  @override
  String toString() {
    return 'Pet{ name: $name, type: $type, age: $age, profilePic: $profilePic, vaccine: $vaccine, weight: $weight, height: $height,}';
  }

  Pet copyWith({
    String? name,
    String? type,
    int? birthdate,
    String? profilePic,
    bool? vaccine,
    double? weight,
    double? height,
  }) {
    return Pet(
      name: name ?? this.name,
      type: type ?? this.type,
      age: birthdate ?? this.age,
      profilePic: profilePic ?? this.profilePic,
      vaccine: vaccine ?? this.vaccine,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'age': age,
      'profilePic': profilePic,
      'vaccine': vaccine,
      'weight': weight,
      'height': height,
    };
  }
  String toJson() => json.encode(toMap());

  factory Pet.fromJson(String source) => Pet.fromMap(json.decode(source));

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      name: map['name'] as String,
      type: map['type'] as String,
      age: map['age'] as int,
      profilePic: map['profilePic'] as String,
      vaccine: map['vaccine'] as bool,
      weight: map['weight'] as double,
      height: map['height'] as double,
    );
  }

//</editor-fold>
}