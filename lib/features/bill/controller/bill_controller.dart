import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/core/type_defs.dart';
import 'package:mpati_pet_care/features/bill/repository/bill_repository.dart';
import 'package:mpati_pet_care/models/bill_model.dart';
import 'package:mpati_pet_care/models/session_model.dart';

import '../../../core/utils.dart';

final billControllerProvider = Provider((ref) => BillController(
    billRepository: ref.watch(billRepositoryProvider), ref: ref)
);

final billBySessionIdProvider = StreamProvider.family<BillModel?, String>((ref, sessionId) {
  final billRepository = ref.read(billRepositoryProvider);
  return billRepository.getBillBySessionId(sessionId);
});
class BillController{
 final BillRepository billRepository;
 final Ref _ref;


  void createBill(BuildContext context,SessionModel sessionModel)async{
    final bill = await billRepository.createBill(sessionModel);
    bill.fold(
            (l) => showSnackBar(context,l.message),
            (r) =>   showSnackBar(context, 'Bill created successfully!')
    );
  }

  Stream<BillModel?> getBillById(String id){
    return billRepository.getBillById(id);
  }

 const BillController({
    required this.billRepository,
    required Ref ref,
  }) : _ref = ref;
}