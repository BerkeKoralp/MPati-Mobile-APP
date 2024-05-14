import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/firebase_constants.dart';
import '../model/chat_model.dart';


final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(firestore: FirebaseFirestore.instance);
});

class ChatRepository {
  final FirebaseFirestore _firestore;


  CollectionReference get _messages => _firestore.collection(FirebaseConstants.messagesCollection);

  Stream<List<ChatMessage>> getMessages(String userId, String peerId) {
    return _messages
        .where('senderId', isEqualTo: userId)
        .where('receiverId', isEqualTo: peerId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatMessage.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList());
  }


  Future<void> sendMessage(ChatMessage message) async {
    await _messages.add({
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'message': message.message,
      'timestamp': message.timestamp,
    });
  }//message.toMap();

  const ChatRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;
}