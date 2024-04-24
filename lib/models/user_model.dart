
import 'dart:convert';
import 'dart:ffi';

import 'pet_model.dart';
class  UserModel {
  final String? name;
  final String? mail;
  final String? password;
  final String? profilePic;
  final String? uid;
  final int? balance;
  final bool? isAuthenticated;
  final String? address;
  final String? type;

//<editor-fold desc="Data Methods">
  const UserModel({
    this.name,
    this.mail,
    this.password,
    this.profilePic,
    this.uid,
    this.balance,
    this.isAuthenticated,
    this.address,
    this.type,
  });

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
          type == other.type);

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
      type.hashCode;

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
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      mail: map['mail'] ?? '',
      password: map['password'] ?? '',
      profilePic: map['profilePic'] ?? '',
      uid: map['uid'] ?? '',
      balance: map['balance']?.toInt() ?? 0 ,
      isAuthenticated: map['isAuthenticated'] ?? false,
      address: map['address'] ?? '',
      type: map['type'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
//</editor-fold>
}