// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/widgets/show_alert.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  var user = FirebaseAuth.instance.currentUser;
  Reference? refStorage;

  CollectionReference notesRef = FirebaseFirestore.instance.collection('notes');

  var TitleNote, SubtitleNote, ImageUrl;

  File? file;

  showBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 180,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const Text(
                'Choose Image',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(
                  'From Gallery',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                onTap: () async {
                  var picked = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    file = File(picked.path);
                    var rand = Random().nextInt(1000);
                    var imageName = '$rand${basename(picked.path)}';
                    refStorage = FirebaseStorage.instance
                        .ref('Account:${user!.email}/Note Images')
                        .child(imageName);
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                onTap: () async {
                  var picked =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    file = File(picked.path);
                    var rand = Random().nextInt(10000);
                    var imageName = '$rand${basename(picked.path)}';
                    refStorage = FirebaseStorage.instance
                        .ref('Account:${user!.email}/Note Images')
                        .child(imageName);
                  }
                  Navigator.of(context).pop();
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text(
                  'From Camera',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  addNote(BuildContext context) async {
    var formData = formstate.currentState;
    if (formData!.validate()) {
      if (file == null) {
        showAlert(context, 'ERROR', 'you have to add image for Note');
        return;
      }
      showLoading(context);
      formData.save();
      await refStorage!.putFile(file!);
      ImageUrl = await refStorage!.getDownloadURL();
      await notesRef.add({
        'Title Note': TitleNote,
        'Subtitle Note': SubtitleNote,
        'image Url': ImageUrl,
        'userUID': user!.uid,
      }).then((value) {
        Navigator.of(context).pushNamed('HomePage');
      }).catchError((e) {
        print('$e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            key: formstate,
            child: Column(
              children: [
                TextFormField(
                  validator: (val) {
                    if (val!.length > 16) {
                      return 'Title Note CAN\'t to be larger than 15 latter';
                    } else if (val.length <= 2) {
                      return 'Title Note CAN\'t to be less than 2 latter';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    TitleNote = val;
                  },
                  textInputAction: TextInputAction.done,
                  maxLength: 15,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Title Note',
                      prefixIcon: Icon(Icons.note)),
                ),
                TextFormField(
                  validator: (val) {
                    if (val!.length >= 251) {
                      return 'Subtitle Note CAN\'t to be larger than 250 latter';
                    } else if (val.length <= 10) {
                      return 'Subtitle Note CAN\'t to be less than 10 latter';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    SubtitleNote = val;
                  },
                  textInputAction: TextInputAction.done,
                  maxLength: 250,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Subtitle Note',
                      prefixIcon: Icon(Icons.note)),
                ),
                ElevatedButton(
                  onPressed: () {
                    showBottomSheet(context);
                  },
                  child: const Text('Add Image for Note'),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await addNote(context);
            },
            style: ElevatedButton.styleFrom(fixedSize: const Size(210, 70)),
            child: const Text(
              'Add the Note',
              style: TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}
