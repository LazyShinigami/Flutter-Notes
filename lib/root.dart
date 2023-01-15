import 'package:flutter/material.dart';
import 'package:notes/authLogic.dart';
import 'package:notes/firebase/back_end_helper.dart';
import 'package:notes/screens/homepage.dart';
import 'firebase/models.dart';

class Root extends StatelessWidget {
  Root({super.key});
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.userStream,
      builder: (context, snapshot) {
        // print("----> ${snapshot.data}");
        // return Center(child: myText("Got data: ${snapshot.data}"));
        if (snapshot.data != null) {
          MyUser user = snapshot.data!;
          // return Center(
          //   child: myText(
          //     snapshot.data!.userID,
          //     color: Colors.white,
          //   ),
          // );
          return Homepage(user: user);
          // return Center(child: myText("Got data: ${snapshot.data}"));
        } else {
          return const AuthLogic();
        }
      },
    );
  }
}
