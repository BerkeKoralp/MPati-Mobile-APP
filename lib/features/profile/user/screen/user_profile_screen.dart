import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/models/user_model.dart';
import 'package:mpati_pet_care/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/common/error_text.dart';
import '../../../../core/common/loader.dart';
import '../../../authentication/controller/auth_controller.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    super.key,
    required this.uid,
  });

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
          data: (user) => Column(
            children: [
              Row(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(20).copyWith(bottom: 70),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic!),
                          radius: 45,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () => navigateToEditUser(context),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                          ),
                          child: const Text('Edit Profile'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name!,
                            style: Theme.of(context).textTheme.headline6),
                        Row(
                          children: [
                            Icon(
                                user.isAuthenticated!
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color:user.isAuthenticated!
                                    ? Colors.green
                                    : Colors.red),
                            SizedBox(width: 4),
                            Text(user.isAuthenticated!
                                ? 'Authenticated'
                                : 'Not Authenticated'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Address',
                  style: TextStyle(
                      color: Palette.darkBrown1
                  ),),
                subtitle: Text(user.address!,
                  style: TextStyle(
                      color: Palette.darkBrown1
                  ),),
              ),
              ListTile(
                leading: Icon(Icons.balance),
                title: Text('Balance:',
                  style: TextStyle(
                      color: Palette.darkBrown1
                  ),),
                subtitle: Text(user.balance.toString(),
                  style: TextStyle(
                      color: Palette.darkBrown1
                  ),),
              ),
              ListTile(
                onTap: () => Routemaster.of(context).push('/pet-page'),
                leading: Icon(Icons.pets),
                title: Text('My Pets',
                  style: TextStyle(
                      color: Palette.darkBrown1
                  ),
                ),
                ),
            ],
          ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
    )
    );
  }

}
