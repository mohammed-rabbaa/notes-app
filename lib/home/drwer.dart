// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Drwer extends StatefulWidget {
  const Drwer({super.key});

  @override
  State<Drwer> createState() => _DrwerState();
}

class _DrwerState extends State<Drwer> {
  var user = FirebaseAuth.instance.currentUser;

  uploadImageFromCamera() async {
    final ImagePicker picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.camera);

    var refStorage =
        FirebaseStorage.instance.ref('Account:${user!.email}/avatar');

    if (image != null) {
      await refStorage.putFile(File(image.path));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email)
          .update({"avatar": await refStorage.getDownloadURL()});
    }
  }

  uploadImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    var refStorage =
        FirebaseStorage.instance.ref('Account:${user!.email}/avatar');

    if (image != null) {
      await refStorage.putFile(File(image.path));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email)
          .update({"avatar": await refStorage.getDownloadURL()});
    }
  }

  showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 175,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const Text(
                  'choose Aavatar',
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
                  onTap: () => uploadImageFromGallery(),
                ),
                ListTile(
                  onTap: () => uploadImageFromCamera(),
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
        });
  }

  getDataUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('${user!.email}')
        .get()
        .then((value) => {
              if (mounted)
                setState(() {
                  userName = value.data()!['username'];
                  avatar = value.data()!['avatar'];
                })
            });
  }

  String userName = '';

  var avatar;

  @override
  void initState() {
    getDataUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text('${user!.email}'),
            currentAccountPicture: avatar == null
                ? CircleAvatar(
                    child: IconButton(
                      onPressed: () {
                        showBottomSheet();
                      },
                      icon: const Icon(Icons.add),
                    ),
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(avatar),
                    child: InkWell(
                      onTap: () => showBottomSheet(),
                    ),
                  ),
          ),
          const ListTile(
            title: Text('About'),
            leading: Icon(Icons.info_outline),
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('Login');
            },
          ),
        ],
      ),
    );
  }
}
