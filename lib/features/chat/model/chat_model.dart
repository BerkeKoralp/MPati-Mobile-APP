import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  factory ChatMessage.fromFirestore(Map<String, dynamic> firestoreDoc) {
    return ChatMessage(
      senderId: firestoreDoc['senderId'] as String,
      receiverId: firestoreDoc['receiverId'] as String,
      message: firestoreDoc['message'] as String,
      timestamp: (firestoreDoc['timestamp'] as Timestamp).toDate(),
    );
  }

//<editor-fold desc="Data Methods">
  const ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          runtimeType == other.runtimeType &&
          senderId == other.senderId &&
          receiverId == other.receiverId &&
          message == other.message &&
          timestamp == other.timestamp);

  @override
  int get hashCode =>
      senderId.hashCode ^
      receiverId.hashCode ^
      message.hashCode ^
      timestamp.hashCode;

  @override
  String toString() {
    return 'ChatMessage{' +
        ' senderId: $senderId,' +
        ' receiverId: $receiverId,' +
        ' message: $message,' +
        ' timestamp: $timestamp,' +
        '}';
  }

  ChatMessage copyWith({
    String? senderId,
    String? receiverId,
    String? message,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': this.senderId,
      'receiverId': this.receiverId,
      'message': this.message,
      'timestamp': this.timestamp,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      message: map['message'] as String,
      timestamp: map['timestamp'] as DateTime,
    );
  }

//</editor-fold>
}