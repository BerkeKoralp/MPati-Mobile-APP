import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/chat_controller.dart';
import '../repository/chat_parameters.dart';
import '../model/chatmessage_model.dart';
import 'chat_repository_provider.dart';

final chatNotifierProvider = StateNotifierProvider.family<ChatNotifier, List<ChatMessage>, ChatParameters>((ref, params) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatNotifier(chatRepository, params.currentUserId, params.peerId);
});
