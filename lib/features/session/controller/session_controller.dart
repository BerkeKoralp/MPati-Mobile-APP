import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/src/either.dart';
import 'package:mpati_pet_care/core/failure.dart';
import 'package:mpati_pet_care/core/type_defs.dart';
import 'package:mpati_pet_care/models/session_model.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../../core/utils.dart';
import '../repository/session_repository.dart';



final careTakingControllerProvider = Provider<CareTakingController>((ref) => CareTakingController(
    repository: ref.read(careTakingRepositoryProvider),
    ref: ref)
);

class CareTakingController {
  final CareTakingRepository _careTakingRepository;
  final Ref _ref;

  Future<void> initiateSession(BuildContext context,SessionModel sessionModel) async {
    await _careTakingRepository.createSession(sessionModel);
  }
  Future<void> endSession (SessionModel sessionModel) async {
    await _careTakingRepository.endSession(sessionModel);
  }

   CareTakingController({
    required CareTakingRepository repository,
     required Ref ref,
  }) : _careTakingRepository = repository,
         _ref = ref, super()
  ;
}