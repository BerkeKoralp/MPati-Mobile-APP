import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/features/bill/controller/bill_controller.dart';
import 'package:mpati_pet_care/features/session/controller/session_controller.dart';
import 'package:mpati_pet_care/models/pet_caretaker_model.dart';
import 'package:mpati_pet_care/models/user_model.dart';
import 'package:mpati_pet_care/theme/palette.dart';
import 'package:routemaster/routemaster.dart';
import '../../features/session/repository/session_repository.dart';
import '../../models/session_model.dart';

final userProviderForCard =
    FutureProvider.family<UserModel?, String>((ref, userId) {
  // Access your UserProfileController to fetch user details
  final userProfileController = ref.watch(authControllerProvider.notifier);
  return userProfileController.getUserData(userId).first;
});
final careTakerProviderForCard =
    FutureProvider.family<PetCareTakerModel?, String>((ref, userId) {
  // Access your UserProfileController to fetch user details
  final userProfileController = ref.watch(authControllerProvider.notifier);
  return userProfileController.getCareTakerData(userId).first;
});

class SessionCard extends ConsumerWidget {
  final SessionModel session;

  SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProviderForCard(session.userId));
    final careTakerAsyncValue =
        ref.watch(careTakerProviderForCard(session.caretakerId));
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
              data: (user) => Text('Pet Owner: ${user!.name} ',
                  style: TextStyle(fontSize: 14)),
              loading: () => CircularProgressIndicator(),
              error: (err, stack) => Text('Failed to load user name',
                  style: TextStyle(fontSize: 14, color: Colors.red)),
            ),
            careTakerAsyncValue.when(
              data: (caretaker) => Text('Pet Care Taker: ${caretaker!.name} ',
                  style: TextStyle(fontSize: 14)),
              loading: () => CircularProgressIndicator(),
              error: (err, stack) => Text('Failed to load caretaker name',
                  style: TextStyle(fontSize: 14, color: Colors.red)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Status: ${session.status}',
                    style: TextStyle(fontSize: 14, color: Colors.green)),
                SizedBox(
                  width: 50,
                ),
                Text("Cost : ${session.cost}",
                    style: TextStyle(fontSize: 14, color: Colors.white))
              ],
            ),
            Text("Start Time: ${session.startTime}"),
            Text("End Time: ${session.endTime}"),
            Row(
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Rate this session"),
                          content: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List<Widget>.generate(5, (index) {
                              return IconButton(
                                icon: Icon(Icons.star_border),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ref
                                      .read(careTakingControllerProvider)
                                      .rateSession(session, index + 1);
                                },
                              );
                            }),
                          ),
                        ),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    icon: Icon(Icons.star_rate),
                    label: Text("Rate:")),
                Spacer(),
                ElevatedButton.icon(
                    onPressed: () {
                      return ref
                          .watch(billControllerProvider)
                          .createBill(context, session);
                    },
                    icon: Icon(Icons.create),
                    label: Text("Create Bill")),
                Row(
                  children: [StarWidget(starCount: session.ownerRating as int)],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      final bill =
                          ref.watch(billBySessionIdProvider(session.id));
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Column(children: [
                                  bill.when(
                                    data: (data) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Bill ID: ${data!.id}',
                                            style: TextStyle(fontSize: 18)),
                                        SizedBox(height: 10),
                                        Text('User ID: ${data.userId}',
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(height: 10),
                                        Text(
                                            'Caretaker ID: ${data.caretakerId}',
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(height: 10),
                                        Text('Amount: \$${data.amount}',
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(height: 10),
                                        Text('Date Issued: ${data.dateIssued}',
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(height: 10),
                                        Text('Status: ${data.status}',
                                            style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                    error: (e, _) => Center(
                                        child: Text('Failed to load pets: $e')),
                                  )
                                ]),
                              ));
                    },
                    icon: Icon(Icons.search_outlined,color: Colors.white,))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class StarWidget extends StatelessWidget {
  final int starCount;

  StarWidget({required this.starCount});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < starCount; i++)
            Icon(
              Icons.star,
              color: Colors.yellow,
              size: 30.0,
            ),
        ],
      ),
    );
  }
}
