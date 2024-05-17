// lib/src/features/invoice/data/models/invoice_model.dart
import 'dart:convert';

class BillModel {
  final String id;
  final String sessionId;
  final String userId;
  final String caretakerId;
  final double amount;
  final DateTime dateIssued;
  final String status;

//<editor-fold desc="Data Methods">
  const BillModel({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.caretakerId,
    required this.amount,
    required this.dateIssued,
    required this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is BillModel &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              sessionId == other.sessionId &&
              userId == other.userId &&
              caretakerId == other.caretakerId &&
              amount == other.amount &&
              dateIssued == other.dateIssued &&
              status == other.status);

  @override
  int get hashCode =>
      id.hashCode ^
      sessionId.hashCode ^
      userId.hashCode ^
      caretakerId.hashCode ^
      amount.hashCode ^
      dateIssued.hashCode ^
      status.hashCode;

  @override
  String toString() {
    return 'InvoiceModel{' +
        ' id: $id,' +
        ' sessionId: $sessionId,' +
        ' userId: $userId,' +
        ' caretakerId: $caretakerId,' +
        ' amount: $amount,' +
        ' dateIssued: $dateIssued,' +
        ' status: $status,' +
        '}';
  }

  BillModel copyWith({
    String? id,
    String? sessionId,
    String? userId,
    String? caretakerId,
    double? amount,
    DateTime? dateIssued,
    String? status,
  }) {
    return BillModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      caretakerId: caretakerId ?? this.caretakerId,
      amount: amount ?? this.amount,
      dateIssued: dateIssued ?? this.dateIssued,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'sessionId': this.sessionId,
      'userId': this.userId,
      'caretakerId': this.caretakerId,
      'amount': this.amount,
      'dateIssued': this.dateIssued.toIso8601String(),
      'status': this.status,
    };
  }

  factory BillModel.fromMap(Map<String, dynamic> map) {
    return BillModel(
      id: map['id'] ?? '',
      sessionId: map['sessionId'] ?? '',
      userId: map['userId'] ?? '',
      caretakerId: map['caretakerId'] ?? '',
      amount: map['amount'] ?? 0.0,
      dateIssued: DateTime.parse(map['dateIssued']),
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BillModel.fromJson(String source) => BillModel.fromMap(json.decode(source));
//</editor-fold>
}
