import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/auth/login.dart';
import 'package:notes_app/auth/sign_up.dart';
import 'package:notes_app/crud/add_note.dart';
import 'package:notes_app/crud/edit_note.dart';
import 'package:notes_app/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

bool isLogin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    isLogin = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin ? const HomePage() : const Login(),
      routes: {
        'Login': (context) => const Login(),
        'SignUp': (context) => const SignUp(),
        'HomePage': (context) => const HomePage(),
        'AddNote': (context) => const AddNote(),
        'EditNote': (context) => const EditNote(),
      },
    );
  }
}
