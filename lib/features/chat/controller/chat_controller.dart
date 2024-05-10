import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/chatmessage_model.dart';
import '../repository/chat_repository.dart';

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final ChatRepository _chatRepository;
  final String currentUserId;
  final String peerId;

  ChatNotifier(this._chatRepository, this.currentUserId, this.peerId) : super([]);

  void loadMessages() async {
    _chatRepository.getMessages(currentUserId, peerId).listen((messages) {
      state = messages;
    });
  }

  Future<void> sendMessage(String messageText) async {
    final message = ChatMessage(
      senderId: currentUserId,
      receiverId: peerId,
      message: messageText,
      timestamp: DateTime.now(),
    );
    await _chatRepository.sendMessage(message);
  }
}
