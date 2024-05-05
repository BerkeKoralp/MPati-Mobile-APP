import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/session_card.dart';
import '../../../models/session_model.dart';
import '../controller/session_controller.dart';
import '../controller/session_list_controller.dart';

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
    final state = ref.watch(careTakingControllerProvider);
    final sessionsState = ref.watch(sessionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Initiate Care Taking Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  TextFormField(
                    controller: _userIdController,
                    decoration: InputDecoration(labelText: 'User ID'),
                  ),
                  TextFormField(
                    controller: _caretakerIdController,
                    decoration: InputDecoration(labelText: 'Caretaker ID'),
                  ),
                  TextFormField(
                    controller: _petIdController,
                    decoration: InputDecoration(labelText: 'Pet ID'),
                  ),
                  TextFormField(
                    controller: _serviceTypeController,
                    decoration: InputDecoration(labelText: 'Service Type'),
                  ),
                  ElevatedButton(
                    onPressed: () => _submitSession(),
                    child: Text('Create/Start Session'),
                  ),
                  if (state is AsyncLoading)
                    CircularProgressIndicator(),
                  if (state is AsyncError)
                    Text('Error: ${state.error}', style: TextStyle(color: Colors.red)),
                  if (state is AsyncData && state.value != null)
                    Text('Session Created: ${state.value}', style: TextStyle(color: Colors.green)),
                ],
              ),
    sessionsState.when(
    data: (List<SessionModel> sessions) {
         if (sessions.isEmpty) {
    return Center(child: Text("No sessions available"));
            }
            return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
    // Using the custom SessionCard widget to display each session
               return SessionCard(session: sessions[index]);
             },
           );
           },
    loading: () => Center(child: CircularProgressIndicator()),
    error: (error, stack) => Center(child: Text("Error: ${error.toString()}")),
    )
            ],
          ),
        ),
      ),
    );
  }

  void _submitSession() {
    final session = SessionModel(
      userId: _userIdController.text,
      caretakerId: _caretakerIdController.text,
      petId: _petIdController.text,
      startTime: DateTime.now(),
      serviceType: _serviceTypeController.text,
      id: '',
      status: '',
      statusUpdates: [],
      photoUrls: [],
    );
    ref.read(careTakingControllerProvider.notifier).initiateSession(session);
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
