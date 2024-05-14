import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/chat_controller.dart';
import '../repository/chat_parameters.dart';

//session açtığını caretakerde ownerinkini , owner de caretakerınkini alacak userprovider.uid
// if else userprovider.type ownerse caretakerid alacak
// routerın içine o girecek
class ChatScreen extends ConsumerWidget {
  final String currentUserId;
  final String peerId;

  ChatScreen({
    Key? key,
    required this.currentUserId,// buralar caretaker ve owner için yapılması lazım sanırım!!
    required this.peerId,
  }) : super(key: key);

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Notifier'ın durumunu dinleme ve UI'da gösterme
    final chatMessages = ref.watch(chatNotifierProvider(ChatParameters(currentUserId: currentUserId, peerId: peerId)));

    // Notifier'ı doğrudan kullanmak için
    final chatNotifier = ref.read(chatNotifierProvider(ChatParameters(currentUserId: currentUserId, peerId: peerId)).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = chatMessages[index];
                bool isMe = message.senderId == currentUserId;
                return ListTile(
                  title: Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue[200] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(message.message),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_textEditingController.text.isNotEmpty) {
                      // Notifier aracılığıyla mesaj gönderme
                      chatNotifier.sendMessage(_textEditingController.text);
                      _textEditingController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}