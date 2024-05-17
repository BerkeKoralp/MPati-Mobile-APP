
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/core/common/caretaker_card.dart';
import 'package:mpati_pet_care/core/common/user_card.dart';
import 'package:mpati_pet_care/features/chat/chat_repository.dart';
import 'package:mpati_pet_care/models/user_model.dart';
import 'package:routemaster/routemaster.dart';


final usersListProvider = StreamProvider((ref) {
  final chatRepo = ref.read(chatRepositoryProvider);
  return chatRepo.getUsers();
} );

final careTakersListProvider = StreamProvider((ref) {
  final chatRepo = ref.read(chatRepositoryProvider);
  return chatRepo.getCareTakers();
} );





class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(),
      body: _buildCareTakerList(context, ref),
    ) ;
  }

  Widget _buildUserList(BuildContext context,WidgetRef ref){
    final userList = ref.watch(usersListProvider);
    return userList.when(
        data: (users){
         return ListView.builder(
            itemCount: users.length,
            itemBuilder: (_, index) => UserCard(
                userModel: users[index],
                onPressed: () => Routemaster.of(context).push('/contact-page/chat-page/${users[index].mail}/${users[index].uid}')
            )
         );
        },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Failed to load session: $e')),
    );
  }

  Widget _buildCareTakerList(BuildContext context, WidgetRef ref){
    final careTakersList = ref.watch(careTakersListProvider);
    return careTakersList.when(
      data: (caretakers){
        return ListView.builder(
            itemCount: caretakers.length,
            itemBuilder: (_, index) => CareTakerCard(
              petCareTakerModel: caretakers[index],
              onPressed: () => Routemaster.of(context).push('/contact-page/chat-page/${caretakers[index].mail}/${caretakers[index].uid}'
              ) ,
            )
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Failed to load session: $e')),
    );
  }
}