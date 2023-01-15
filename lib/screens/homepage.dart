import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase/back_end_helper.dart';
import 'package:notes/common.dart';
import 'package:notes/firebase/models.dart';
import 'package:notes/screens/noteDetails.dart';
import 'package:notes/screens/note_view.dart';

class Homepage extends StatefulWidget {
  MyUser user;
  Homepage({required this.user, super.key});

  @override
  State<Homepage> createState() => _HomepageState(user);
}

class _HomepageState extends State<Homepage> {
  MyUser user;
  final colors = ColorPallete();

  _HomepageState(this.user);

  late Future name;

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    name = getUsersName(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar
      appBar: AppBar(
        title: myText("Home Page", color: Colors.white, size: 22, spacing: 5),
        centerTitle: true,
      ),

      // drawer
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        ),
        child: Container(
          // decoration:
          //     BoxDecoration(border: Border.all(width: 5, color: Colors.red)),
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myText(
                "Hi 👋",
                weight: FontWeight.bold,
                size: 25,
                spacing: 1,
              ),
              FutureBuilder(
                future: name,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var data = snapshot.data!.data() as Map;
                    return myText(
                      data['name'],
                      weight: FontWeight.bold,
                      size: 35,
                      spacing: 2,
                    );
                  } else {
                    return CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: colors.purplePallete[800],
                    );
                  }
                },
              ),
              myText("Good to have you back!"),
              Divider(
                color: colors.purplePallete[800],
                thickness: 1,
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  _auth.signOut();
                },
                child: Row(
                  children: [
                    const Icon(Icons.logout_rounded),
                    const SizedBox(width: 10),
                    myText(
                      "Logout",
                      spacing: 2,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _auth.signOut();
                },
                child: Row(
                  children: [
                    const Icon(Icons.swap_vert),
                    const SizedBox(width: 10),
                    myText(
                      "Switch Account",
                      spacing: 2,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // body
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _auth.getUsersDataStream(user: user),
          builder: (context, snapshot) {
            // Waiting for data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return myText(
                "Loading data... Please wait!",
                color: colors.purplePallete[800],
                weight: FontWeight.bold,
                size: 25,
              );
            }

            // In case the waiting is done and we receive some kind of error
            if (snapshot.hasError) {
              return myText("Something wend totally fucking wrong");
            }

            // In case when waiting is done and we have our data
            var ourData;
            try {
              ourData = snapshot.data!.data() as Map<String, dynamic>;
              user.username = ourData['username'];
              user.name = ourData['name'];
              user.notes = ourData['userNotes'];
            } catch (e) {
              print(e);
            }

            // return myText("Apna data => ${user.notes}");
            return gridBuilder(user);
          },
        ),
      ),

      // floating action button
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteView(
                noteKey: "",
                user: user,
                noteValue: "",
                operation: "add",
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add_rounded,
          size: 35,
        ),
      ),
    );
  }

  Widget gridBuilder(MyUser user) {
    List keys;
    int totalNotes = 0;

    if (user.notes!.isNotEmpty) {
      keys = user.notes!.keys.toList();
      totalNotes = keys.length;

      return GridView.count(
        mainAxisSpacing: 30,
        crossAxisSpacing: 15,
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
        crossAxisCount: 2,
        children: [
          if (user.notes != null)
            for (int i = 0; i < totalNotes; i++)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 2, color: colors.purplePallete[500]!),
                  boxShadow: [
                    BoxShadow(
                      color: colors.purplePallete[900]!,
                      blurRadius: 0.4, // soften the shadow
                      spreadRadius: 0, //extend the shadow
                      offset: const Offset(
                        -5.0, // Move to right 5  horizontally
                        8.0, // Move to bottom 5 Vertically
                      ),
                    )
                  ],
                  color: colors.purplePallete[400],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onLongPress: () {
                    _showPopup(context, noteKey: keys[i]);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteView(
                          operation: "update",
                          user: user,
                          noteKey: keys[i],
                          noteValue: user.notes![keys[i]],
                        ),
                      ),
                    );
                    // print("${keys[i]} TileTapped");
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: myText(
                            keys[i],
                            weight: FontWeight.bold,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        Divider(
                          height: 16,
                          color: colors.purplePallete[700],
                          thickness: 1,
                        ),
                        myText(
                          user.notes![keys[i]],
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      );
    } else {
      return Center(child: myText("No notes added yet!"));
    }
  }

  _showPopup(BuildContext context, {required String noteKey}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: myText("Delete Note?"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              IconButton(
                onPressed: () {
                  try {
                    var _auth = AuthService();
                    _auth.deleteNote(user: user, noteKey: noteKey);
                  } catch (e) {
                    print(
                        "Some shit went wrong on HomePage widget --------------> $e");
                  }
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              )
            ],
          ),
        );
      },
    );
  }

  Future getUsersName(MyUser user) async {
    String name = "";
    var _store = _auth.firestoreObject;
    var res = await _store.collection("NotesDB").doc(user.email).get();
    return res;
  }
}
