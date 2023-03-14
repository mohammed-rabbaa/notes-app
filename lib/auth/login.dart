// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/widgets/show_alert.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  var email, password;
  logIN() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      showLoading(context);
      formData.save();
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          showAlert(context, 'Error', 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          showAlert(context, 'Error', 'Wrong password provided for that user.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 100,
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
              key: formState,
              child: Column(
                children: [
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
                        const Text('If you haven\'t Account '),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('SignUp');
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
                      UserCredential? response = await logIN();
                      if (response != null) {
                        Navigator.of(context).pushReplacementNamed('HomePage');
                      }
                    },
                    child: const Text(
                      'LOGIN',
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
