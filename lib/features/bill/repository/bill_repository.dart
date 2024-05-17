import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mpati_pet_care/core/failure.dart';
import 'package:mpati_pet_care/core/providers/firebase_providers.dart';
import 'package:mpati_pet_care/core/type_defs.dart';
import 'package:mpati_pet_care/models/session_model.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../models/bill_model.dart';

final billsProviderForUser = StreamProvider.family<List<BillModel>, String>((ref, userId) async* {
  final stream = ref.read(firestoreProvider).collection('bills').where('userId', isEqualTo: userId).snapshots();
  await for (final snapshot in stream) {
    yield snapshot.docs.map((doc) => BillModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
});

final billsProviderForCareTaker = StreamProvider.family<List<BillModel>, String>((ref, userId) async* {
  final stream = ref.read(firestoreProvider).collection('bills').where('caretakerId', isEqualTo: userId).snapshots();
  await for (final snapshot in stream) {
    yield snapshot.docs.map((doc) => BillModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
});

final billRepositoryProvider = Provider<BillRepository>((ref) => BillRepository(
    firestore: ref.read(firestoreProvider)
));

class BillRepository{
  final FirebaseFirestore _firestore;

  const BillRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _bills => _firestore.collection(FirebaseConstants.billsCollection);
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _caretakers => _firestore.collection(FirebaseConstants.petCareTakerCollection);

  FutureEither<BillModel?> createBill(SessionModel sessionModel) async{
      BillModel bill;
    try{
      bill = BillModel(
          id: '',
          sessionId: sessionModel.id,
          userId: sessionModel.userId,
          caretakerId: sessionModel.caretakerId,
          amount: sessionModel.cost!,
          dateIssued: sessionModel.startTime,
          status: "care-taking-service"
      );
      DocumentReference result = await _bills.add(bill.toMap());
      String billId = result.id;
      await _bills.doc(billId).update({
        'id': billId,
      });
      await _updateUserAndCaretakerBills(billId, sessionModel.userId, sessionModel.caretakerId);

      return right(bill.copyWith(id: billId));
    }
    catch(e){
      return left(Failure('Failed to create bill: ${e.toString()}'));
    }

  }
  Future<void> _updateUserAndCaretakerBills(String billId, String userId, String caretakerId) async {
    await _users.doc(userId).update({
      'bills': FieldValue.arrayUnion([billId])
    });
    await _caretakers.doc(caretakerId).update({
      'bills': FieldValue.arrayUnion([billId])
    });
  }
  Stream<BillModel?> getBillBySessionId(String sessionId) {
    return _bills
        .where('sessionId', isEqualTo: sessionId)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return BillModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  Stream<BillModel?> getBillById(String billId)  {
    return _bills.doc(billId).snapshots().map((event) => BillModel.fromMap(event.data() as Map<String, dynamic>));
  }



}