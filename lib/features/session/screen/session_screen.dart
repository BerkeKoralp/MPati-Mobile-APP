import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/models/pet_caretaker_model.dart';
import 'package:mpati_pet_care/models/pet_model.dart';
import 'package:mpati_pet_care/theme/palette.dart';

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
  double bill=0.0;
  double weight=1;
  double height=1;
  DateTime? selectedDate; // Field to store selected date

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
                      // petCareTakerModel= PetCareTakerModel.fromMap(value);
                      careTakerId = value['uid'];
                      // bill = (value['weight']*0.3)+value['height']*0.2;
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
                        weight= value ['weight'];
                        height = value ['height'];
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
                            backgroundColor: Colors.transparent,
                            child: SizedBox(
                                width: 60,
                                height: 60,
                                child: ClipOval(
                                  child: Image.asset("assets/images/default_pet_profile.png",
                                  ),
                                )
                            ),
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
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    primary: Palette.nutellaBrown
                ),
                onPressed: () => _selectDate(context),
                icon: Icon(Icons.calendar_month),
                label: const Text('Select Date'),
              ),
              Text(selectedDate == null ? 'No Date Chosen' : 'Selected Date: ${selectedDate!.toLocal()}',
                  style: TextStyle(
                      color: Colors.red
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Palette.nutellaBrown
                ),
                onPressed: () => _submitSession(context, userId),
                child: const Text('Start Care Taking'),
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
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(), // Initial date to show in the picker
      firstDate: DateTime.now(), // Earliest allowable date
      lastDate: DateTime(2100), // Latest allowable date
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitSession(BuildContext context, String userId) {
    final session = SessionModel(
      userId: userId,
      caretakerId: careTakerId,
      petId: petId,
      startTime: DateTime.now(),
      serviceType: 'Service Type', // Example placeholder
      id: '',
      status: 'deactive',
      statusUpdates: [],
      photoUrls: [],
      cost: weight*0.3+height*0.5,
      endTime: selectedDate,
    );
    ref.read(careTakingControllerProvider).initiateSession(context, session);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
