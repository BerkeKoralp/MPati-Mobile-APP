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

final caretakerListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final querySnapshot = await ref.read(firestoreProvider).collection('caretakers')
      .where('isActive', isEqualTo: true).get();
  return querySnapshot.docs.map((doc) => {
    'uid': doc.id,
    'name': doc.data()['name'] ?? 'No name',
    'profilePic': doc.data()['profilePic'] ?? 'assets/images/default_profile_pic.png',
  }).toList();
});

final userPetsDetailsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) async {
  final querySnapshot = await ref.read(firestoreProvider).collection('pets').where('ownerId', isEqualTo: userId).get();
  return querySnapshot.docs.map((doc) => {
    'petId': doc.id,
    'name': doc.data()['name'] ?? 'No Name',
    'profilePic': doc.data()['profilePic'] ?? 'assets/images/default_pet_profile.png'
  }).toList();
});

class CareTakingScreen extends ConsumerStatefulWidget {
  @override
  _CareTakingScreenState createState() => _CareTakingScreenState();
}

class _CareTakingScreenState extends ConsumerState<CareTakingScreen> {
   String careTakerId="";
   String petId= "";
  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userProvider)!.uid!;
    final sessionsState = ref.watch(sessionListProvider(userId));
    final caretakers = ref.watch(caretakerListProvider);
    final pets = ref.watch(userPetsDetailsProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Initiate Care Taking Session'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DropdownButtonFormField<Map<String, dynamic>>(
                value: null,
                onChanged: (value) {
                  if (value != null) {
                      setState(() {
                        careTakerId = value['uid'];
                      });
                  }
                },
                items: caretakers.when(
                  data: (list) => list.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> caretaker) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: caretaker,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(caretaker['profilePic']),
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(width: 10),
                          Text(caretaker['name']),
                        ],
                      ),
                    );
                  }).toList(),
                  loading: () => [DropdownMenuItem(child: Text("Loading..."))],
                  error: (_, __) => [DropdownMenuItem(child: Text("Failed to load data"))],
                ),
                decoration: const InputDecoration(labelText: 'Choose Caretaker'),
              ),

              DropdownButtonFormField<Map<String, dynamic>>(
                value: null,
                onChanged: (value) {
                  if (value != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        petId = value['petId'];
                      });
                    });
                  }
                },
                items: pets.when(
                  data: (list) => list.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> pet) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: pet,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(pet['profilePic']),
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(width: 10),
                          Text(pet['name']),
                        ],
                      ),
                    );
                  }).toList(),
                  loading: () => [DropdownMenuItem(child: Text("Loading..."))],
                  error: (_, __) => [DropdownMenuItem(child: Text("Failed to load data"))],
                ),
                decoration: const InputDecoration(labelText: 'Pet'),
              ),
              ElevatedButton(
                onPressed: () => _submitSession(context, userId),
                child: const Text('Create/Start Session'),
              ),
              sessionsState.when(
                data: (sessions) => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: sessions.length,
                  itemBuilder: (_, index) => SessionCard(session: sessions[index]),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Failed to load session: $e')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitSession(BuildContext context, String userId) {
    final session = SessionModel(
      userId: userId,
      caretakerId: careTakerId,
      petId: petId,
      startTime: DateTime.now(),
      serviceType: 'Service Type', // Example placeholder
      id: '',
      status: 'active',
      statusUpdates: [],
      photoUrls: [],
    );
    ref.read(careTakingControllerProvider).initiateSession(context, session);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
