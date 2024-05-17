import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SessionModel {
  final String id;
  final String userId;
  final String caretakerId;
  final String petId;
  final DateTime startTime;
  final DateTime? endTime;
  final String status;
  final List<String> statusUpdates;
  final String? caretakerFeedback;
  final String? ownerFeedback;
  final int? caretakerRating;
  final int? ownerRating;
  final List<String> photoUrls;
  final double? cost;
  final String serviceType;
  final String? description;


//<editor-fold desc="Data Methods">
  const SessionModel({
    required this.id,
    required this.userId,
    required this.caretakerId,
    required this.petId,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.statusUpdates,
    this.caretakerFeedback,
    this.ownerFeedback,
    this.caretakerRating,
    this.ownerRating,
    required this.photoUrls,
    this.cost,
    required this.serviceType,
    this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          caretakerId == other.caretakerId &&
          petId == other.petId &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          status == other.status &&
          statusUpdates == other.statusUpdates &&
          caretakerFeedback == other.caretakerFeedback &&
          ownerFeedback == other.ownerFeedback &&
          caretakerRating == other.caretakerRating &&
          ownerRating == other.ownerRating &&
          photoUrls == other.photoUrls &&
          cost == other.cost &&
          serviceType == other.serviceType &&
          description== other.description);

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      caretakerId.hashCode ^
      petId.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      status.hashCode ^
      statusUpdates.hashCode ^
      caretakerFeedback.hashCode ^
      ownerFeedback.hashCode ^
      caretakerRating.hashCode ^
      ownerRating.hashCode ^
      photoUrls.hashCode ^
      cost.hashCode ^
      serviceType.hashCode ^
      description.hashCode;

  @override
  String toString() {
    return 'SessionModel{' +
        ' id: $id,' +
        ' userId: $userId,' +
        ' caretakerId: $caretakerId,' +
        ' petId: $petId,' +
        ' startTime: $startTime,' +
        ' endTime: $endTime,' +
        ' status: $status,' +
        ' statusUpdates: $statusUpdates,' +
        ' caretakerFeedback: $caretakerFeedback,' +
        ' ownerFeedback: $ownerFeedback,' +
        ' caretakerRating: $caretakerRating,' +
        ' ownerRating: $ownerRating,' +
        ' photoUrls: $photoUrls,' +
        ' cost: $cost,' +
        ' serviceType: $serviceType,' +
        'description: $description,'
        '}';
  }

  SessionModel copyWith({
    String? id,
    String? userId,
    String? caretakerId,
    String? petId,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    List<String>? statusUpdates,
    String? caretakerFeedback,
    String? ownerFeedback,
    int? caretakerRating,
    int? ownerRating,
    List<String>? photoUrls,
    double? cost,
    String? serviceType,
    String? description,
  }) {
    return SessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      caretakerId: caretakerId ?? this.caretakerId,
      petId: petId ?? this.petId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      statusUpdates: statusUpdates ?? this.statusUpdates,
      caretakerFeedback: caretakerFeedback ?? this.caretakerFeedback,
      ownerFeedback: ownerFeedback ?? this.ownerFeedback,
      caretakerRating: caretakerRating ?? this.caretakerRating,
      ownerRating: ownerRating ?? this.ownerRating,
      photoUrls: photoUrls ?? this.photoUrls,
      cost: cost ?? this.cost,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'userId': this.userId,
      'caretakerId': this.caretakerId,
      'petId': this.petId,
      'startTime': this.startTime,
      'endTime': this.endTime,
      'status': this.status,
      'statusUpdates': this.statusUpdates,
      'caretakerFeedback': this.caretakerFeedback,
      'ownerFeedback': this.ownerFeedback,
      'caretakerRating': this.caretakerRating,
      'ownerRating': this.ownerRating,
      'photoUrls': this.photoUrls,
      'cost': this.cost,
      'serviceType': this.serviceType,
      'description' : this.description,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      caretakerId: map['caretakerId'] ?? '',
      petId: map['petId'] ?? '',
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: map['endTime'] != null ? (map['endTime'] as Timestamp).toDate() : null,
      status: map['status'] ?? '',
      statusUpdates:(map['statusUpdates'] != null) ? List<String>.from(map['statusUpdates']) : [],
      caretakerFeedback: map['caretakerFeedback'] ?? '',
      ownerFeedback: map['ownerFeedback'] ?? '',
      caretakerRating: map['caretakerRating'] ?? 0,
      ownerRating: map['ownerRating'] ?? 0,
      photoUrls: (map['photoUrls'] != null) ? List<String>.from(map['photoUrls']) : [],
      cost: map['cost'] ?? 0.0,
      serviceType: map['serviceType'] ?? '',
      description: map['description'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());

  factory SessionModel.fromJson(String source) => SessionModel.fromMap(json.decode(source));
//</editor-fold>
}