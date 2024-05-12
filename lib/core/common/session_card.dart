import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/features/profile/user/controller/user_profile_controller.dart';
import 'package:mpati_pet_care/models/user_model.dart';

import '../../models/session_model.dart';

final userProviderForCard = FutureProvider.family<UserModel?, String>((ref, userId) {
  // Access your UserProfileController to fetch user details
  final userProfileController = ref.watch(authControllerProvider.notifier);
  return userProfileController.getUserData(userId).first;
});

class SessionCard extends ConsumerWidget {
  final SessionModel session;

  SessionCard({required this.session});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final userNameAsyncValue = ref.watch(userProviderForCard(session.userId));
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Session ID: ${session.id}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('User ID: ${session.userId}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Care Taker Id: ${session.caretakerId}', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('Status: ${session.status ?? "Pending"}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}