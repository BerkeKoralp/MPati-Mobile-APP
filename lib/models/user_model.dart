
import 'dart:convert';
import 'dart:core';

import 'package:mpati_pet_care/models/base_model.dart';

class  UserModel extends BaseModel{
  final String? name;
  final String? profilePic;
  final int? balance;
  final bool? isAuthenticated;
  final String? address;
  final List<String> bills;
  final List<String> pets;
  final List<String> sessionIds;

//<editor-fold desc="Data Methods">
  const UserModel({
   required this.sessionIds,
    this.name,
    String? mail,
    String? password,
    String? type,
    String? uid,
    this.profilePic,
    this.balance,
    this.isAuthenticated,
    this.address,
    required this.bills,
    required this.pets,

  }):super(mail:  mail,password:  password,type: type,uid:  uid);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          mail == other.mail &&
          password == other.password &&
          profilePic == other.profilePic &&
          uid == other.uid &&
          balance == other.balance &&
          isAuthenticated == other.isAuthenticated &&
          address == other.address &&
          type == other.type &&
          bills == other.bills &&
          pets == other.pets &&
          sessionIds== other.sessionIds);

  @override
  int get hashCode =>
      name.hashCode ^
      mail.hashCode ^
      password.hashCode ^
      profilePic.hashCode ^
      uid.hashCode ^
      balance.hashCode ^
      isAuthenticated.hashCode ^
      address.hashCode ^
      type.hashCode ^
      bills.hashCode ^
      pets.hashCode ^
      sessionIds.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' name: $name,' +
        ' mail: $mail,' +
        ' password: $password,' +
        ' profilePic: $profilePic,' +
        ' uid: $uid,' +
        ' balance: $balance,' +
        ' isAuthenticated: $isAuthenticated,' +
        ' address: $address,' +
        ' type: $type,' +
        ' bills: $bills,' +
        ' pets: $pets,' +
        'sessionId $sessionIds,'+
        '}';
  }

  UserModel copyWith({
    String? name,
    String? mail,
    String? password,
    String? profilePic,
    String? uid,
    int? balance,
    bool? isAuthenticated,
    String? address,
    String? type,
    List<String>? bills,
    List<String>? pets,
    List<String>? sessionIds,

  }) {
    return UserModel(
      name: name ?? this.name,
      mail: mail ?? this.mail,
      password: password ?? this.password,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      balance: balance ?? this.balance,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      address: address ?? this.address,
      type: type ?? this.type,
      bills: bills ?? this.bills,
      pets: pets ?? this.pets,
      sessionIds: sessionIds ?? this.sessionIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'mail': this.mail,
      'password': this.password,
      'profilePic': this.profilePic,
      'uid': this.uid,
      'balance': this.balance,
      'isAuthenticated': this.isAuthenticated,
      'address': this.address,
      'type': this.type,
      'bills': this.bills,
      'pets': this.pets,
      'sessionIds':this.sessionIds,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name']  ?? '',
      mail: map['mail']  ?? '',
      password: map['password']  ?? '',
      profilePic: map['profilePic']  ?? '',
      uid: map['uid']  ?? '',
      balance: map['balance']  ?? '',
      isAuthenticated: map['isAuthenticated']  ?? '',
      address: map['address']  ?? '',
      type: map['type']  ?? '',
      bills:(map['bills'] != null) ? List<String>.from(map['bills']) : [],
      pets: (map['pets'] != null) ? List<String>.from(map['pets']) : [],
      sessionIds: (map['sessionIds'] != null) ? List<String>.from(map['sessionIds']) : [],
    );
  }
  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

//</editor-fold>
}