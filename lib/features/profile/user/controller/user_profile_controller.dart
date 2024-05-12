import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/providers/storage_repository_provider.dart';
import '../../../../core/utils.dart';
import '../../../../models/user_model.dart';
import '../../../authentication/controller/auth_controller.dart';
import '../repository/user_profile_repository.dart';
final userProfileControllerProvider = StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;

  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editProfile({
    required File? profileFile,
    required Uint8List? profileWebFile,
    required BuildContext context,
    required String name,
  }) async {
    state = true;
    UserModel? user = _ref.read(userProvider) as UserModel;

    if (profileFile != null || profileWebFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid!,
        file: profileFile,
        webFile: profileWebFile,
      );
      res.fold(
            (l) => showSnackBar(context, l.message),
            (r) => user = user!.copyWith(profilePic: r),
      );
    }
    user = user!.copyWith(name: name);
    final res = await _userProfileRepository.editProfile(user!);
    state = false;
    res.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }

}
