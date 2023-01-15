import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  String email = "";
  String? name;
  String? username;
  Map<String, dynamic>? notes;
  // String password = "";
  MyUser({required this.email}) {}
  MyUser.fromFirebaseUser(User user) {
    email = user.email!;
  }
}
