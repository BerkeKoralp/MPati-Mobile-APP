import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/models/base_model.dart';

import '../../../core/utils.dart';
import '../../../models/user_model.dart';
import '../repository/auth_repository.dart';

final userProvider = StateProvider<BaseModel?>((ref) => null);
final typeOfAccountProvider = StateProvider<String>((ref) => "owner");
final authControllerProvider = StateNotifierProvider<AuthController,bool>(
        (ref) =>
        AuthController(
            authRepository: ref.watch(authRepositoryProvider),
            ref: ref)
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});
final getUserDataProvider = StreamProvider.family((ref,String uid){
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.findUserInRoleCollections(uid)!;
});
//final getUserDataProvider = StreamProvider.family<String>((ref,String uid)  {
//   final authController = ref.watch(authControllerProvider.notifier);
//   return authController.findUserInRoleCollections(uid);
// });
class AuthController extends StateNotifier<bool>{
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,

  })  : _authRepository = authRepository,
        _ref = ref, super(false);//loading

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signUpWithEmailAndPassword (BuildContext context, {required String email, required String password,required String type})async{
    state = true;
    _ref.read(authRepositoryProvider).signupWithEmailAndPassword(email: email, password: password,type: type);
    state = false;

  }
  void signInWithEmailAndPassword (BuildContext context,{required String email, required String password,required String type}) async {
    state = true;
    print(email);
    print(password);

    final user= await _authRepository.signInWithEmailAndPassword(email, password,type);
    state = false;
    user.fold(
          (l) => showSnackBar(context, l.message),
          (userModel) => _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }
  void signInWithGoogle(BuildContext context,String type) async {
    state= true;
    final user = await _authRepository.signInWithGoogle(type: type);
    state= false;
    //This is how we are catching errors
    user.fold(
          (l) => showSnackBar(context, l.message),
          (userModel) => _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }
  Stream<BaseModel>? findUserInRoleCollections(String uid){
    return _authRepository.findUserInRoleCollections(uid);
  }
  void logout() async {
    _authRepository.logOut();
  }
}
