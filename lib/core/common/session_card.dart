import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/models/pet_caretaker_model.dart';
import 'package:mpati_pet_care/models/user_model.dart';
import '../../models/session_model.dart';

final userProviderForCard = FutureProvider.family<UserModel?, String>((ref, userId) {
  // Access your UserProfileController to fetch user details
  final userProfileController = ref.watch(authControllerProvider.notifier);
  return userProfileController.getUserData(userId).first;
});
final careTakerProviderForCard = FutureProvider.family<PetCareTakerModel?, String>((ref, userId) {
  // Access your UserProfileController to fetch user details
  final userProfileController = ref.watch(authControllerProvider.notifier);
  return userProfileController.getCareTakerData(userId).first;
});

class SessionCard extends ConsumerWidget {
  final SessionModel session;

  SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final userAsyncValue = ref.watch(userProviderForCard(session.userId));
    final careTakerAsyncValue = ref.watch(careTakerProviderForCard(session.caretakerId));
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Session ID: ${session.id}"),
            SizedBox(height: 8),
            userAsyncValue.when(
              data: (user) => Text('Pet Owner: ${user!.name} ', style: TextStyle(fontSize: 14)),
              loading: () => CircularProgressIndicator(),
              error: (err, stack) => Text('Failed to load user name', style: TextStyle(fontSize: 14, color: Colors.red)),
            ),
            careTakerAsyncValue.when(
              data: (caretaker) => Text('Pet Care Taker: ${caretaker!.name} ', style: TextStyle(fontSize: 14)),
              loading: () => CircularProgressIndicator(),
              error: (err, stack) => Text('Failed to load caretaker name', style: TextStyle(fontSize: 14, color: Colors.red)),
            ),
            const SizedBox(height: 8),
            Text('Status: ${session.status}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}