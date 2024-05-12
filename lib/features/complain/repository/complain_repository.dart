import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mpati_pet_care/core/constants/firebase_constants.dart';

class ComplainRepository {
  final FirebaseFirestore _firestore;
  CollectionReference get _complain => _firestore.collection(FirebaseConstants.complaintsCollection);

  const ComplainRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;


  void submitComplain(){

  }
}