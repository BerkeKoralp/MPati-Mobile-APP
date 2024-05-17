


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/core/providers/firebase_providers.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/models/message.dart';
import 'package:mpati_pet_care/models/pet_caretaker_model.dart';
import 'package:mpati_pet_care/models/user_model.dart';

import '../../core/constants/firebase_constants.dart';

final chatRepositoryProvider =
Provider<ChatRepository>((ref) => ChatRepository(ref: ref,
  firestore:ref.watch(firestoreProvider),)
);


class ChatRepository {
  final Ref _ref;
  final FirebaseFirestore _firestore;

  const ChatRepository({
    required FirebaseFirestore firestore,
    required Ref ref
  }) : _firestore = firestore,
        _ref = ref;


  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _caretakers =>
      _firestore.collection(FirebaseConstants.petCareTakerCollection);

  CollectionReference get _chatrooms =>
      _firestore.collection(FirebaseConstants.chatRoomsCollection);
  //Get App Users Stream

  Stream<List<UserModel>> getUsers() {
    return _users.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
  Stream<List<PetCareTakerModel>> getCareTakers() {
    return _caretakers.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PetCareTakerModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }


  //Send message
Future<void> sendMessage (String receiverId,message) async{
    final currentUserId = _ref.watch(userProvider)!.uid;
    final currentUserMail = _ref.watch(userProvider)!.mail;
    final Timestamp timeStamp = Timestamp.now();

    Message newMessage = Message(
        senderId: currentUserId!,
        senderEmail: currentUserMail!,
        receiverId: receiverId,
        message: message,
        timestamp: timeStamp
    );

    List<String> ids = [currentUserId,receiverId];

    ids.sort();// this ensures the chatRoomId is the same for any 2 people

    String chatRoomId= ids.join('_');

    await _chatrooms.doc(chatRoomId).collection("messages").add(newMessage.toMap());

}

//Getting messages

Stream<QuerySnapshot> getMessages(String userId,otherUserId){


    //construc chatroom ıd
  List<String> ids = [userId,otherUserId];
  ids.sort();
  String chatRoomId = ids.join('_');

  return _chatrooms
      .doc(chatRoomId)
      .collection("messages")
      .orderBy("timestamp",descending: false)
      .snapshots();
}



}