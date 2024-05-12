import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/session_card.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../models/session_model.dart';
import '../../authentication/controller/auth_controller.dart';
import '../controller/session_controller.dart';
final sessionListProvider = StreamProvider.family<List<SessionModel>, String>((ref, userId) async* {
  final stream = ref.read(firestoreProvider).collection('sessions').where('userId', isEqualTo: userId).snapshots();
  await for (final snapshot in stream) {
    yield snapshot.docs.map((doc) => SessionModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
});
class CareTakingScreen extends ConsumerStatefulWidget {
  @override
  _CareTakingScreenState createState() => _CareTakingScreenState();
}

class _CareTakingScreenState extends ConsumerState<CareTakingScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _caretakerIdController = TextEditingController();
  final TextEditingController _petIdController = TextEditingController();
  final TextEditingController _serviceTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userProvider)!.uid;
    final sessionsState = ref.watch(sessionListProvider(userId!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Initiate Care Taking Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            TextFormField(
              controller: _caretakerIdController,
              decoration: const InputDecoration(labelText: 'Caretaker ID'),
            ),
            TextFormField(
              controller: _petIdController,
              decoration: const InputDecoration(labelText: 'Pet ID'),
            ),
            TextFormField(
              controller: _serviceTypeController,
              decoration: const InputDecoration(labelText: 'Service Type'),
            ),
            ElevatedButton(
              onPressed: () => _submitSession(context),
              child: const Text('Create/Start Session'),
            ),
            Expanded(
              child: sessionsState.when(
                data: (sessions) => ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (_, index) => SessionCard(session: sessions[index]),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Failed to load session: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _submitSession(BuildContext context) {
    final session = SessionModel(
      userId: _userIdController.text,
      caretakerId: _caretakerIdController.text,
      petId: _petIdController.text,
      startTime: DateTime.now(),
      serviceType: _serviceTypeController.text,
      id: '',
      status: 'active',
      statusUpdates: [],
      photoUrls: [],
    );
    ref.read(careTakingControllerProvider).initiateSession(context,session);
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _caretakerIdController.dispose();
    _petIdController.dispose();
    _serviceTypeController.dispose();
    super.dispose();
  }
}
