import 'package:flutter/material.dart';
import 'package:notes/common.dart';

class NotesDetail extends StatefulWidget {
  String noteKey, noteValue;

  NotesDetail({super.key, required this.noteKey, required this.noteValue});

  @override
  State<NotesDetail> createState() =>
      _NotesDetailState(noteKey: noteKey, noteValue: noteValue);
}

class _NotesDetailState extends State<NotesDetail> {
  String noteKey, noteValue;
  _NotesDetailState({required this.noteKey, required this.noteValue});
  final colors = ColorPallete();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.purplePallete[100],
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.purplePallete[800],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myText(
              noteKey,
              color: colors.purplePallete[800],
              size: 27.5,
              weight: FontWeight.w400,
              spacing: 0.5,
              wordSpacing: 5,
            ),
            Divider(height: 30, thickness: 1, color: colors.purplePallete[900]),
            myText(
              noteValue,
              size: 18,
              height: 1.5,
              color: colors.purplePallete[800],
              weight: FontWeight.w500,
              wordSpacing: 2.5,
              spacing: -0.25,
            ),
            // Text(
            //   "ksamnivbuvvkjnsv\vsavsav\avs\n\nsvs\nsfa\nsacev",
            //   style: TextStyle(height: 2),
            // )
          ],
        ),
      ),
    );
  }
}
