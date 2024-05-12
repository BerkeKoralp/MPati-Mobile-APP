import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});


class Palette {
  static const nutellaBrown = Color.fromRGBO(140,75,0,1);
  static const lightBrown1 = Color.fromRGBO(191,127,63,1);
  static const darkBrown1 = Color.fromRGBO(102,51,0,1);
  static const whiteBrown1 = Color.fromRGBO(242,232,224,1);
  static const brown1 = Color.fromRGBO(166,75,0,1);
  static const whiteColor = Colors.white;

  static const String fontFamily = 'Acme';

 static var darkModeAppTheme = ThemeData.dark().copyWith(
   textTheme: ThemeData.dark().textTheme.copyWith(
     // Set the font family for the entire app
     bodyText1: const TextStyle(fontFamily: Palette.fontFamily),
     bodyText2: const TextStyle(fontFamily: Palette.fontFamily),

     // Add more text styles as needed
   ),
    scaffoldBackgroundColor: whiteBrown1,
    cardColor: darkBrown1,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBrown1,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: brown1,
    ),
    primaryColor: lightBrown1,
    // will be used as alternative background color
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.copyWith(
      // Set the font family for the entire app
      bodySmall: const TextStyle(fontFamily: Palette.fontFamily),
      bodyMedium: const TextStyle(fontFamily: Palette.fontFamily),
      // Add more text styles as needed
    ),
    scaffoldBackgroundColor:whiteBrown1 ,
    cardColor: darkBrown1,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBrown1,
      elevation: 0,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: nutellaBrown,
  );
}
class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  ThemeNotifier({ThemeMode mode = ThemeMode.dark})
      : _mode = mode,
        super(
        Palette.darkModeAppTheme,
      ) {
    getTheme();
  }

  ThemeMode get mode => _mode;

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');

    if (theme == 'light') {
      _mode = ThemeMode.light;
      state = Palette.lightModeAppTheme;
    } else {
      _mode = ThemeMode.dark;
      state = Palette.darkModeAppTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = Palette.lightModeAppTheme;
      prefs.setString('theme', 'light');
    } else {
      _mode = ThemeMode.dark;
      state = Palette.darkModeAppTheme;
      prefs.setString('theme', 'dark');
    }
  }
}