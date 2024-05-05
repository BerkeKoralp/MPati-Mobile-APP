import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/failure.dart';
import '../../../core/utils.dart';
import '../../../models/session_model.dart';
import '../repository/session_repository.dart';
final sessionListProvider = StateNotifierProvider<SessionListController, AsyncValue<List<SessionModel>>>((ref) {
  return SessionListController(careTakingRepository: ref.read(careTakingRepositoryProvider),ref: ref);
});

class SessionListController extends StateNotifier<AsyncValue<List<SessionModel>>> {
  final CareTakingRepository _careTakingRepository;
  final Ref ref;



  Future<void> loadSessions() async {
    state = const AsyncValue.loading();
    try {
      List<SessionModel> sessions = (await _careTakingRepository.fetchSessions()) as List<SessionModel>;

      state = AsyncValue.data(sessions);
    } catch (error) {
      state = AsyncValue.error(Failure(error.toString()),StackTrace.fromString(error.toString()));
    }
  }
  void addSession(SessionModel session) {
    state.whenData((sessions) => state = AsyncValue.data([...sessions, session]));
  }
   SessionListController( {
    required this.ref,
    required CareTakingRepository careTakingRepository,
  }) : _careTakingRepository = careTakingRepository,super(const AsyncValue.loading())
   {
  loadSessions();
}
}
