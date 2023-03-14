// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/widgets/show_alert.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  var userName, email, password;

  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  signUP(context) async {
    var formData = formstate.currentState;
    if (formData!.validate()) {
      showLoading(context);
      formData.save();
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          showAlert(context, 'Error', 'The password provided is too weak');
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          showAlert(
              context, 'Error', 'The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 75,
          ),
          Center(
            child: Container(
              height: 175,
              width: 175,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [BoxShadow(blurRadius: 5)],
                image: const DecorationImage(
                  image: AssetImage(
                    'images/512.png',
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formstate,
              child: Column(
                children: [
                  TextFormField(
                    validator: (val) {
                      if (val!.length > 50) {
                        return 'username CAN\'t to be larger than 50 latter';
                      } else if (val.length < 3) {
                        return 'username CAN\'t to be less than 3 latter';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      userName = val;
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'username',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.length > 150) {
                        return 'Email CAN\'t to be larger than 150 latter';
                      } else if (val.length < 7) {
                        return 'Email CAN\'t to be less than 7 latter';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      email = val;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.length > 100) {
                        return 'Password CAN\'t to be larger than 100 latter';
                      } else if (val.length < 5) {
                        return 'Password CAN\'t to be less than 5 latter';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      password = val;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        )),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Text('If you have Account '),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed('Login');
                          },
                          child: const Text(
                            'Click Here',
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      UserCredential? response = await signUP(context);
                      if (response != null) {
                        userRef.doc('$email').set({
                          'username': userName,
                          'Email': email,
                          'password': password,
                        });
                        Navigator.of(context).pushReplacementNamed('HomePage');
                      }
                    },
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
