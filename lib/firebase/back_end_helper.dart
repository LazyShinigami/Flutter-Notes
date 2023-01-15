// // FOR ANY HELP, GO HERE: https://www.youtube.com/watch?v=TkuO8OLgvkk&list=PLlvRDpXh1Se4wZWOWs8yapI8AS_fwDHzf&index=3
// // ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/firebase/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Firestore object
  final _store = FirebaseFirestore.instance;

  // Firebase auth object
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore get firestoreObject {
    return _store;
  }

  // Getter for MyUser object stream
  Stream<MyUser> get userStream {
    var result = _auth.authStateChanges();
    return result.map((user) {
      return MyUser.fromFirebaseUser(user!);
    });
  }

  //
  // SIGN IN METHODS
  //
  // - with email and password
  Future signInWithEmailAndPassword({String? email, String? password}) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //
  // SIGN UP METHODS
  //
  // - with email and password
  Future signUpWithEmailAndPassword({String? email, String? password}) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // - with credentials -- this is an appendage to signing up with just email and password
  Future signUpWithUserCredentials({
    String? name,
    String? username,
    String? email,
    String? password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      await _store.collection("NotesDB").doc(email).set({
        'name': name,
        'username': username,
        'email': email,
        'userNotes': {},
      });
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //
  // SIGN OUT METHOD
  //
  Future signOut() async {
    _auth.signOut();
  }

  //
  // RESET PASSWORD METHOD
  //
  Future resetPassword({required String email}) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //
  // GET DATA
  //
  // - user id (the randomly generated document id basically)
  Future<List<String>> getAllDocIDs() async {
    List<String> docIDs = [];
    var userIDs = await _store.collection("NotesDB").get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              docIDs.add(document.reference.id);
            },
          ),
        );
    return docIDs;
  }

  // Return a stream of MyUser Object
  Stream getDataStream({required MyUser user}) {
    var notesDB = _store.collection("NotesDB").snapshots();
    return notesDB;
  }

  // Resource to understand this: https://firebase.flutter.dev/docs/firestore/usage
  Stream<DocumentSnapshot> getUsersDataStream({required MyUser user}) {
    var docReference = _store.collection("NotesDB").doc(user.email).snapshots();
    return docReference;
  }

  deleteNote({required MyUser user, required String noteKey}) {
    try {
      var allNotes = user.notes;
      allNotes!.remove(noteKey);
      _store
          .collection("NotesDB")
          .doc(user.email)
          .update({'userNotes': allNotes});
    } catch (e) {
      print(e);
    }
  }

  // target a specific collection
  targeCollection({required String collectionName}) {
    return _store.collection(collectionName);
  }

  bool addOrUpdateNote({
    required String operation,
    required MyUser user,
    required Map<String, String> originalKVpair,
    required Map<String, String> newKVpair,
  }) {
    bool flag = true;

    try {
      var allNotes = user.notes!;
      var OGkey = originalKVpair.keys.toList()[0];
      var OGvalue = originalKVpair.values.toList()[0];
      var NEWkey = newKVpair.keys.toList()[0];
      var NEWvalue = newKVpair.values.toList()[0];
      switch (operation) {
        //
        // Add
        //
        case "add":
          allNotes.addAll({NEWkey: NEWvalue});
          _store
              .collection("NotesDB")
              .doc(user.email)
              .update({'userNotes': allNotes});

          break;

        //
        // Update
        //
        case "update":
          allNotes.remove(OGkey);
          allNotes.addAll({NEWkey: NEWvalue});
          _store
              .collection("NotesDB")
              .doc(user.email)
              .update({'userNotes': allNotes});
          break;
      }
    } catch (e) {
      flag = false;
    }
    return flag;
  }
}
