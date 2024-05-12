import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/models/base_model.dart';
import 'package:mpati_pet_care/models/pet_caretaker_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../../core/utils.dart';
import '../../../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../screens/role_selection_screen_google.dart';

final userProvider = StateProvider<BaseModel?>((ref) => null);
final typeOfAccountProvider = StateProvider<String>((ref) => "caretaker");
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

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});
final getCareTakerDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getCareTakerData(uid);
});


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
          (baseModel) =>  _ref.read(userProvider.notifier).update((state) => baseModel),
    );
  }
  void signInWithGoogle(BuildContext context) async {
    state = true;
    final result = await _authRepository.signInWithGoogle(type: _ref.read(typeOfAccountProvider)
    );
    state = false;
    result.fold(
          (failure) {
        showSnackBar(context, failure.message);
      },
          (user) {
        if (user == null) {
          // User is new and needs to choose a role
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChooseTypeScreen(
            onRoleChosen: (chosenType) {
              createUserWithType(context, chosenType);
            },
          )));

        } else {
          // Existing user, update the state directly
          _ref.read(userProvider.notifier).update((state) => user);
        }
      },
    );
  }

  void createUserWithType(BuildContext context, String type) {
    _authRepository.createUserWithType(type).then((result) {
      result.fold(
            (failure) => showSnackBar(context, failure.message),
            (user) => _ref.read(userProvider.notifier).update((state) => user),
      );
    });
    Routemaster.of(context).push('/');
  }

  Stream<BaseModel>? findUserInRoleCollections(String uid,String type){
    return _authRepository.findUserInRoleCollections(uid,type);
  }
  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
  Stream<PetCareTakerModel> getCareTakerData(String uid) {
    return _authRepository.getCareTakerData(uid);
  }

  void logout() async {
    _authRepository.logOut();
  }
}
