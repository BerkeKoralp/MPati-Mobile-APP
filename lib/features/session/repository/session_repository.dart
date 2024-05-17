import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mpati_pet_care/core/type_defs.dart';
import 'package:mpati_pet_care/models/session_model.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
final careTakingRepositoryProvider = Provider<CareTakingRepository>((ref) {
  return CareTakingRepository(
    firestore: ref.read(firestoreProvider)
    ,
  );
});

class CareTakingRepository {
  final FirebaseFirestore _firestore;

  const CareTakingRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;


  CollectionReference get _sessions =>
      _firestore.collection(FirebaseConstants.sessionCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _caretakers =>
      _firestore.collection(FirebaseConstants.petCareTakerCollection);

  CollectionReference get _pets =>
      _firestore.collection(FirebaseConstants.petsCollection);

  FutureEither<bool> validateSessionPreconditions(SessionModel session) async {
    try {
      DocumentSnapshot userDoc = await _users.doc(session.userId).get();
      DocumentSnapshot caretakerDoc = await _caretakers.doc(session.caretakerId)
          .get();
      DocumentSnapshot petDoc = await _pets.doc(session.petId).get();

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>? ??
          {};
      Map<String, dynamic> caretakerData = caretakerDoc.data() as Map<
          String,
          dynamic>? ?? {};
      // Map<String, dynamic> petData = petDoc.data() as Map<String, dynamic>? ??
      //     {};

      bool userActive = userDoc.exists && userData['isAuthenticated'] == true;
      bool caretakerActive = caretakerDoc.exists &&
          caretakerData['isAuthenticated'] == true;
      bool petExists = petDoc.exists;

      if(session.status =="active"){
        return left(Failure("Session is already in use !"));
      }

      if (userActive && caretakerActive && petExists) {
        return right(true); // Conditions are met
      } else {
        return left(Failure(
            'One or more entities do not meet the conditions for session creation.'));
      }
    } catch (e) {
      return left(
          Failure('Error checking session preconditions: ${e.toString()}'));
    }
  }
  Future<void> rateSession(String sessionId, int rating) async {
    await _sessions.doc(sessionId).update({'ownerRating': rating});
  }
  FutureEither<List<SessionModel>> fetchSessions() async {
    try {
      QuerySnapshot snapshot = await _sessions.get();
      return right(snapshot.docs.map((doc) => SessionModel.fromMap(doc as Map<String, dynamic>)).toList());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
  FutureEither<SessionModel?> createSession(SessionModel session) async {
    Either<Failure, bool> validation = await validateSessionPreconditions(
        session);
    return validation.fold(
            (failure) => left(failure),
            (valid) {
          if (!valid) { 
            return left(
                Failure('Validation failed for user, caretaker, or pet.'));
          }

          return _tryCreatingSession(session);
        }
    );
  }
  FutureEither<SessionModel> _tryCreatingSession(SessionModel session) async {
    try {
      print('Creating session');
      DocumentReference result = await _sessions.add(session.toMap());
      String sessionId = result.id;
      await _sessions.doc(sessionId).update({
        'id': sessionId,
        'status': "active",
      });
      await _updateUserAndCaretakerSessionLinks(sessionId, session.userId, session.caretakerId);
      await _updateCaretakerActivity(session.caretakerId, false);
      return right(session.copyWith(id: sessionId));  // Assuming copyWith is implemented to handle ID
    } catch (e) {
      return left(Failure('Failed to create session: ${e.toString()}'));
    }
  }

  Future<void> _updateCaretakerActivity(String caretakerId, bool isActive) async {
    await _caretakers.doc(caretakerId).update({
      'isActive': isActive,
    });
  }

  Future<void> _updateUserAndCaretakerSessionLinks(String sessionId, String userId, String caretakerId) async {
    await _users.doc(userId).update({
      'sessionIds': FieldValue.arrayUnion([sessionId])
    });
    await _caretakers.doc(caretakerId).update({
      'sessionIds': FieldValue.arrayUnion([sessionId])
    });
  }

  Future<void> endSession (SessionModel sessionModel)async {

  }
}

