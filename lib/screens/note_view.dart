// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:notes/common.dart';
import 'package:notes/firebase/back_end_helper.dart';
import 'package:notes/firebase/models.dart';

class NoteView extends StatefulWidget {
  String noteKey, noteValue;
  MyUser user;
  String operation;
  NoteView(
      {super.key,
      required this.operation,
      required this.noteKey,
      required this.user,
      required this.noteValue});

  @override
  State<NoteView> createState() => _NoteViewState(
      noteKey: noteKey, noteValue: noteValue, user: user, operation: operation);
}

class _NoteViewState extends State<NoteView> {
  String noteKey, noteValue;
  MyUser user;
  String operation;
  _NoteViewState(
      {required this.operation,
      required this.noteKey,
      required this.noteValue,
      required this.user});

  final colors = ColorPallete();
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    bool canWeGoBack = false;
    String newNoteKey = noteKey;
    String newNoteValue = noteValue;
    return WillPopScope(
      onWillPop: () async {
        if (newNoteKey.isEmpty && newNoteValue.isEmpty) {
          canWeGoBack = true;
          Navigator.pop(context);
        } else {
          if (newNoteKey != noteKey || newNoteValue != noteValue) {
            String _validated = _validate(newNoteKey, newNoteValue, noteKey);

            if (_validated.isEmpty) {
              // we will add or update note as we have no error
              _auth.addOrUpdateNote(
                operation: operation,
                user: user,
                originalKVpair: {noteKey: noteValue},
                newKVpair: {newNoteKey: newNoteValue},
              );

              canWeGoBack = true;

              Navigator.pop(context);
              // setState(() {});
            } else {
              _buildPopup(
                title: _validated,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: myText(
                      "Cancel",
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: myText("Okay"),
                  ),
                ],
              );
            }
          } else {
            canWeGoBack = true;
            Navigator.pop(context);
          }
        }
        return canWeGoBack;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              // back button
              GestureDetector(
                onTap: () {
                  if (newNoteKey.isEmpty && newNoteValue.isEmpty) {
                    canWeGoBack = true;
                    Navigator.pop(context);
                  } else {
                    if (newNoteKey != noteKey || newNoteValue != noteValue) {
                      String _validated =
                          _validate(newNoteKey, newNoteValue, noteKey);

                      if (_validated.isEmpty) {
                        // we will add or update note as we have no error
                        _auth.addOrUpdateNote(
                          operation: operation,
                          user: user,
                          originalKVpair: {noteKey: noteValue},
                          newKVpair: {newNoteKey: newNoteValue},
                        );

                        canWeGoBack = true;

                        Navigator.pop(context);
                        // setState(() {});
                      } else {
                        _buildPopup(
                          title: _validated,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: myText(
                                "Cancel",
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: myText("Okay"),
                            ),
                          ],
                        );
                      }
                    } else {
                      canWeGoBack = true;
                      Navigator.pop(context);
                    }
                  }
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: colors.purplePallete[800],
                ),
              ),

              const SizedBox(width: 10),

              // NOTE TITLE
              Expanded(
                child: TextFormField(
                  initialValue: noteKey,
                  decoration: const InputDecoration.collapsed(
                      hintText: "Add note title"),
                  cursorColor: colors.purplePallete[800],
                  cursorWidth: 3,
                  cursorRadius: const Radius.circular(50),
                  style: TextStyle(
                    color: colors.purplePallete[800],
                    fontSize: 27.5,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                    wordSpacing: 5,
                    fontFamily: 'HindSiliguri',
                  ),
                  onChanged: (value) {
                    newNoteKey = value;
                  },
                ),
              ),
            ],
          ),
          backgroundColor: colors.purplePallete[100],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(thickness: 1, color: colors.purplePallete[900]),
              const SizedBox(height: 15),

              // NOTE BODY
              TextFormField(
                maxLines: 9999,
                keyboardType: TextInputType.multiline,
                initialValue: noteValue,
                decoration: const InputDecoration.collapsed(
                    hintText: "Add note details"),
                cursorColor: colors.purplePallete[800],
                cursorWidth: 3,
                cursorRadius: const Radius.circular(50),
                style: TextStyle(
                  color: colors.purplePallete[800],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  wordSpacing: 2.5,
                  fontFamily: 'HindSiliguri',
                ),
                onChanged: (value) {
                  newNoteValue = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _validate(String noteKey, String noteValue, String originalNoteKey) {
    String message = "";

    // all keys
    List<String> allKeys = user.notes!.keys.toList();

    if (noteKey.length <= 0) {
      if (operation == "add") {
        message =
            "Providing a unique title for your note is important.\nProceeding will discard this note!";
      } else {
        message =
            "Providing a unique title for your note is important.\nProceeding will discard changes!";
      }
    }
    if (allKeys.contains(noteKey) && noteKey != originalNoteKey) {
      message =
          "There already exists a note with the same title.\nTry again with a different title!";
    }
    return message;
  }

  _buildPopup({required String title, List<Widget>? children}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: myText(title),
            content: Row(
                mainAxisAlignment: (children!.length <= 1)
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceEvenly,
                children: children),
          );
        });
  }
}
