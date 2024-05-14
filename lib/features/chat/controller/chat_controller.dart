import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/chat_model.dart';
import '../model/chat_model.dart';
import '../repository/chat_parameters.dart';
import '../repository/chat_repository.dart';

final chatNotifierProvider = StateNotifierProvider.family<ChatNotifierController,
    List<ChatMessage>, ChatParameters>((ref, params) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatNotifierController(chatRepository, params.currentUserId, params.peerId);
});

class ChatNotifierController extends StateNotifier<List<ChatMessage>> {
  final ChatRepository _chatRepository;
  final String currentUserId;
  final String peerId;

  ChatNotifierController(this._chatRepository, this.currentUserId, this.peerId)
      : super([]);

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
