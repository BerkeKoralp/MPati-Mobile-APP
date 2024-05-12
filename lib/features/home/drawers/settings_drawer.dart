import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/features/home/user/home_page.dart';
import 'package:mpati_pet_care/theme/palette.dart';

import '../../authentication/controller/auth_controller.dart';
class SettingDrawer extends ConsumerWidget {
  const SettingDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }
  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
      ListTile(
      title: const Text('Log Out'),
        leading: Icon(
          Icons.logout,
        ),
        onTap: () => logOut(ref),
      ),Switch.adaptive(
            value: ref.watch(themeNotifierProvider.notifier).mode == ThemeMode.dark,
            onChanged: (val) => toggleTheme(ref),
          ),
        ],
      ),
    ),) ;
  }
}
