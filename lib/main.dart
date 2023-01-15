import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes/firebase/back_end_helper.dart';
import 'package:notes/root.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'firebase/models.dart';

Future<void> main() async {
  // Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var colors = ColorPallete();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: colors.purplePallete[500],
          selectedIconTheme: IconThemeData(color: colors.purplePallete[500]),
          unselectedIconTheme: IconThemeData(color: colors.purplePallete[300]),
          elevation: 0,
        ),
        scaffoldBackgroundColor: colors.purplePallete[100],
        appBarTheme: AppBarTheme(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          toolbarHeight: 60,
          backgroundColor: colors.purplePallete[600],
        ),
        drawerTheme: DrawerThemeData(
            elevation: 200,
            backgroundColor: colors.purplePallete[100],
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(30)))),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            backgroundColor: colors.purplePallete[600],
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colors.purplePallete[600],
        ),
      ),
      home: Root(),
    );
  }
}
