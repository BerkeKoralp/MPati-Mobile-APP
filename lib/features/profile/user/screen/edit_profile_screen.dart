import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mpati_pet_care/models/user_model.dart';

import '../../../../core/common/error_text.dart';
import '../../../../core/common/loader.dart';
import '../../../../core/utils.dart';
import '../../../../responsive/responsive.dart';
import '../../../../theme/palette.dart';
import '../../../authentication/controller/auth_controller.dart';
import '../controller/user_profile_controller.dart';
class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? profileFile;
  Uint8List? profileWebFile;
  late TextEditingController nameController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider) as UserModel;
    nameController = TextEditingController(text: user.name);
    addressController = TextEditingController(text: user.address);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    addressController.dispose();
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          profileWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
      profileFile: profileFile,
      context: context,
      name: nameController.text.trim(),
      profileWebFile: profileWebFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
        data: (user) =>
            Scaffold(
              backgroundColor: currentTheme.backgroundColor,
              appBar: AppBar(
                title: const Text('Edit Profile'),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: save,
                    child: const Text('Save'),
                  ),
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Responsive(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: GestureDetector(
                                onTap: selectProfileImage,
                                child: profileWebFile != null
                                    ? CircleAvatar(
                                  backgroundImage: MemoryImage(profileWebFile!),
                                  radius: 32,
                                )
                                    : profileFile != null
                                    ? CircleAvatar(
                                  backgroundImage: FileImage(profileFile!),
                                  radius: 32,
                                )
                                    : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      user.profilePic!),
                                  radius: 32,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //NAME
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Name',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(18),
                        ),
                      ),
                      //
                      TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Adress',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader()
    );
  }
}

