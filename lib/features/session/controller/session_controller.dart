import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/src/either.dart';
import 'package:mpati_pet_care/core/failure.dart';
import 'package:mpati_pet_care/features/session/controller/session_list_controller.dart';
import 'package:mpati_pet_care/models/session_model.dart';

import '../repository/session_repository.dart';


final careTakingControllerProvider = StateNotifierProvider<CareTakingController,AsyncValue<SessionModel?>>((ref) => CareTakingController(
    repository: ref.read(careTakingRepositoryProvider),
    ref: ref)
);

class CareTakingController extends StateNotifier<AsyncValue<SessionModel?>> {
  final CareTakingRepository _careTakingRepository;
  final Ref _ref;

  Future<void> initiateSession(SessionModel sessionModel) async {
    state = const AsyncValue.loading();
    try {
      Either<Failure, SessionModel?> result = await _careTakingRepository.createSession(sessionModel);
      result.fold(
              (failure) {
            // Handle the failure case, you might want to transform the failure to a message or similar
            state = AsyncValue.error(Failure(failure.toString()),StackTrace.fromString(failure.toString()));
          },
              (sessionModel) {
                if (sessionModel != null) {
                  // If session creation is successful, update the state
                  state = AsyncValue.data(sessionModel);
                  // Additionally, refresh or update the session list
                  _ref.read(sessionListProvider.notifier).addSession(sessionModel);
                } else {
                  // Handle the case where session is null (if applicable)
                   state = AsyncValue.error(Failure("Session is Null"),StackTrace.fromString("asd"));
                }
          }
      );
    } catch (e) {
      state = AsyncValue.error(Failure(e.toString()),StackTrace.fromString(e.toString()));
    }
  }

   CareTakingController({
    required CareTakingRepository repository,
     required Ref ref,
  }) : _careTakingRepository = repository,
         _ref = ref, super(AsyncValue.data(null))
  ;
}