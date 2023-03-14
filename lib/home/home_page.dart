// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/crud/edit_note.dart';
import 'package:notes_app/home/drwer.dart';
import 'package:notes_app/home/view_page.dart';
import 'package:notes_app/widgets/show_alert.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference notesRef = FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: const Drwer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('AddNote');
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: FutureBuilder(
        future: notesRef
            .where('userUID',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, i) {
                return Dismissible(
                  onDismissed: (direction) async {
                    await notesRef.doc(snapshot.data!.docs[i].id).delete();
                    await FirebaseStorage.instance
                        .refFromURL(snapshot.data!.docs[i]['image Url'])
                        .delete();
                  },
                  key: UniqueKey(),
                  child: ListNotes(
                    notes: snapshot.data!.docs[i],
                    docid: snapshot.data!.docs[i].id,
                  ),
                );
              },
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('no notes yet'));
          }
          return showLoading(context);
        },
      ),
    );
  }
}

class ListNotes extends StatelessWidget {
  const ListNotes({super.key, this.notes, this.docid});
  final notes;
  final docid;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ViewNote(
            notes: notes,
          );
        }));
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network('${notes['image Url']}'),
            ),
            Expanded(
              flex: 3,
              child: ListTile(
                title: Text(
                  '${notes['Title Note']}',
                  style: const TextStyle(fontSize: 18),
                ),
                subtitle: Text('${notes['Subtitle Note']}'),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return EditNote(
                        docid: docid,
                        list: notes,
                      );
                    }));
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
