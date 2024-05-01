
import 'dart:convert';

import 'base_model.dart';

class PetCareTakerModel extends BaseModel{

  final String? name;
  final String? profilePic;
  final int? balance;
  final bool? isAuthenticated;
  final String? address;
  final List<String>? session;
  final List<String>? bills;

//<editor-fold desc="Data Methods">
  const PetCareTakerModel({
    String? mail,
    String? password,
    String? type,
    String? uid,
    this.name,
    this.profilePic,
    this.balance,
    this.isAuthenticated,
    this.address,
    this.session,
    this.bills,
  }):super(mail: mail,password: password,type: type , uid: uid);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PetCareTakerModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          profilePic == other.profilePic &&
          uid == other.uid &&
          balance == other.balance &&
          isAuthenticated == other.isAuthenticated &&
          address == other.address &&
          session == other.session &&
          bills == other.bills);

  @override
  int get hashCode =>
      name.hashCode ^
      profilePic.hashCode ^
      uid.hashCode ^
      balance.hashCode ^
      isAuthenticated.hashCode ^
      address.hashCode ^
      session.hashCode ^
      bills.hashCode;

  @override
  String toString() {
    return 'PetCareTakerModel{' +
        ' name: $name,' +
        ' profilePic: $profilePic,' +
        ' uid: $uid,' +
        ' balance: $balance,' +
        ' isAuthenticated: $isAuthenticated,' +
        ' address: $address,' +
        ' session: $session,' +
        ' bills: $bills,' +
        '}';
  }

  PetCareTakerModel copyWith({
    String? name,
    String? profilePic,
    String? uid,
    int? balance,
    bool? isAuthenticated,
    String? address,
    List<String>? session,
    List<String>? bills,
  }) {
    return PetCareTakerModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      balance: balance ?? this.balance,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      address: address ?? this.address,
      session: session ?? this.session,
      bills: bills ?? this.bills,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'profilePic': this.profilePic,
      'uid': this.uid,
      'balance': this.balance,
      'isAuthenticated': this.isAuthenticated,
      'address': this.address,
      'session': this.session,
      'bills': this.bills,
      'type': this.type,
      'mail' :this.mail,
      'password' : this.password,
    };
  }

  factory PetCareTakerModel.fromMap(Map<String, dynamic> map) {
    return PetCareTakerModel(
      name: map['name']?? '',
      profilePic: map['profilePic'] ?? '',
      mail: map['mail']  ?? '',
      password: map['password']  ?? '',
      uid: map['uid'] ?? '',
      balance: map['balance'] as int,
      isAuthenticated: map['isAuthenticated'] as bool,
      address: map['address'] ?? '',
      type: map['type']  ?? '',
      session: (map['session'] != null) ? List<String>.from(map['session']) : [],
      bills: (map['bills'] != null) ? List<String>.from(map['bills']) : [],
    );
  }
  String toJson() => json.encode(toMap());

  factory PetCareTakerModel.fromJson(String source) => PetCareTakerModel.fromMap(json.decode(source));
//</editor-fold>
}