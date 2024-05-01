
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
final balanceRepositoryProvider = Provider((ref) => BalanceRepository(
    firestore: ref.read(firestoreProvider),
    ref: ref
));

class BalanceRepository {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  const BalanceRepository({
    required FirebaseFirestore firestore,
    required Ref ref,
  })  : _firestore = firestore,
        _ref = ref;
}