import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/usermodel.dart';

class Authentication {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required BuildContext context}) async {
    String result = 'error';
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        // register user
        final signupResult = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // store userdata
        UserModel user = UserModel(
          email: email,
          username: username,
          uid: signupResult.user!.uid,
        );
        await firestore.collection('users').doc(signupResult.user!.uid).set(
              user.toJson(),
            );
        result = 'success';
      }
    } on FirebaseAuthException catch (e) {
      result = e.toString();
      log(e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
    }
    return result;
  }

  Future<void> logInUser(
      {required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
  }
}
