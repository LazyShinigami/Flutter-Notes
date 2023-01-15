import 'package:flutter/material.dart';
import 'package:notes/screens/login.dart';
import 'package:notes/screens/signUp.dart';

class AuthLogic extends StatefulWidget {
  const AuthLogic({super.key});

  @override
  State<AuthLogic> createState() => _AuthLogicState();
}

class _AuthLogicState extends State<AuthLogic> {
  bool showLoginPage = true;

  // callback function
  void toggleScreen() {
    showLoginPage = !showLoginPage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(showSignUpPage: toggleScreen);
    } else {
      return SignUp(showLoginPage: toggleScreen);
    }
  }
}
