
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/core/common/my_textField.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/features/chat/chat_repository.dart';


class ChatParameters {
  final String currentUserId;
  final String otherUserId;

  ChatParameters({required this.currentUserId, required this.otherUserId});
}
final messagesStreamProvider = StreamProvider.family<QuerySnapshot,ChatParameters>((ref,params) {
  final chatRepo = ref.read(chatRepositoryProvider);
  return chatRepo.getMessages(params.currentUserId, params.otherUserId);
} );

class ChatScreen extends ConsumerStatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const ChatScreen( {
    super.key,
    required this.receiverId,
    required this.receiverEmail});

  @override
  ConsumerState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title:  Text(widget.receiverEmail),),
      body:Column(children: [
        //Displayin all messages
        Expanded(child: _buildMessageList(  )
        ),


        //user input
        _buildUserInput(ref)
      ],
      ) ,
    );
  }
  void sendMessage() async {

    if(_messageController.text.isNotEmpty){
      await ref.watch(chatRepositoryProvider).sendMessage(widget.receiverId, _messageController.text);

      _messageController.clear();
    }

  }


  Widget _buildMessageList() {
    final user = ref.watch(userProvider);
    if (user == null) {
      return Center(child: Text("User not logged in"));
    }

    String senderId = user.uid!;

    return StreamBuilder<QuerySnapshot>(
      stream: ref.read(chatRepositoryProvider).getMessages(senderId, widget.receiverId),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data?.docs != null
    ? ListView.builder(
    itemCount: snapshot.data?.docs.length,
    itemBuilder: (context, index) {
    return _buildMessageItem(snapshot.data!.docs[index]);
            },
    )
        : Container();
    },
    );
  }



  Widget _buildMessageItem (DocumentSnapshot documentSnapshot) {

    Map<String,dynamic>  data = documentSnapshot.data() as Map<String,dynamic>;
    bool isSentByMe = data["senderId"] == ref.read(userProvider)!.uid;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Align(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: isSentByMe ? Colors.blue[100] : Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: isSentByMe ? Radius.circular(10) : Radius.circular(0),
              bottomRight: isSentByMe ? Radius.circular(0) : Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data["message"] ?? 'No message content',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              Text(
                data["senderEmail"] ?? 'Unknown sender',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  return Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
  //       child: Align(
  //         alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
  //         child: Container(
  //           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
  //           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
  //           decoration: BoxDecoration(
  //             color: isSentByMe ? Colors.blue[100] : Colors.grey[200],
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(10),
  //               topRight: Radius.circular(10),
  //               bottomLeft: isSentByMe ? Radius.circular(10) : Radius.circular(0),
  //               bottomRight: isSentByMe ? Radius.circular(0) : Radius.circular(10),
  //             ),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 data["message"] ?? 'No message content',
  //                 style: TextStyle(fontSize: 16),
  //               ),
  //               SizedBox(height: 5),
  //               Text(
  //                 data["senderEmail"] ?? 'Unknown sender',
  //                 style: TextStyle(fontSize: 12, color: Colors.grey),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  Widget _buildUserInput(WidgetRef ref){
    return Row(children: [
      Expanded(
          child: MyTextField(
            controller :_messageController,
            hintText: "Type a message",
            obsecureText: false,
          ))
      ,IconButton(
          onPressed:sendMessage,
          icon: Icon(Icons.send))
    ],);
  }
}


