import 'dart:convert';

import 'package:mpati_pet_care/models/pet_model.dart';

class Receipt {
  final double costOfService;
  final String description;
  final String date;
  final Pet pet;

//<editor-fold desc="Data Methods">
  const Receipt({
    required this.costOfService,
    required this.description,
    required this.date,
    required this.pet,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Receipt &&
          runtimeType == other.runtimeType &&
          costOfService == other.costOfService &&
          description == other.description &&
          date == other.date &&
          pet == other.pet);

  @override
  int get hashCode =>
      costOfService.hashCode ^
      description.hashCode ^
      date.hashCode ^
      pet.hashCode;

  @override
  String toString() {
    return 'Receipt{' +
        ' costOfService: $costOfService,' +
        ' description: $description,' +
        ' date: $date,' +
        ' pet: $pet,' +
        '}';
  }

  Receipt copyWith({
    double? costOfService,
    String? description,
    String? date,
    Pet? pet,
  }) {
    return Receipt(
      costOfService: costOfService ?? this.costOfService,
      description: description ?? this.description,
      date: date ?? this.date,
      pet: pet ?? this.pet,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'costOfService': this.costOfService,
      'description': this.description,
      'date': this.date,
      'pet': this.pet,
    };
  }
  String toJson() => json.encode(toMap());

  factory Receipt.fromJson(String source) => Receipt.fromMap(json.decode(source));

  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      costOfService: map['costOfService'] ??0,
      description: map['description']  ??'',
      date: map['date']  ??'',
      pet: map['pet'],
    );
  }

//</editor-fold>
}