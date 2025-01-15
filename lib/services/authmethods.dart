import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/models/usermodel.dart';
import 'package:instagram/services/storage.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    if (!snap.exists) {
      throw Exception('User document does not exist');
    }
    return UserModel.fromJson(snap.data() as Map<String, dynamic>);
  }

  Future<String> signUp({
    required String email,
    required String password,
    required String userName,
    required Uint8List file,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || userName.isEmpty) {
        return "All fields are required";
      }
      if (password.length < 6) {
        return "Password must be at least 6 characters long";
      }
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String photoUrl = await StorageMethods().uploadImageToStorage(
        'profilePic',
        file,
        false,
      );

      UserModel user = UserModel(
          email: email,
          uid: credential.user!.uid,
          photoUrl: photoUrl,
          userName: userName,
          bio: '',
          followers: [],
          following: []);

      await _firestore.collection("users").doc(credential.user!.uid).set(
            user.toJson(),
          );
      return 'success creating account';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'email-already-in-use':
          return 'An account already exists for this email.';
        case 'invalid-email':
          return 'The email address is not valid.';
        default:
          return 'Authentication error: ${e.message}';
      }
    } catch (e) {
      return 'An unexpected error occurred: ${e.toString()}';
    }
  }

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return 'Please fill all fields';
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return 'success';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email';
        case 'wrong-password':
          return 'Incorrect password';
        case 'invalid-email':
          return 'Invalid email format';
        default:
          return 'Login failed: ${e.message}';
      }
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  Future<String> signout() async {
    try {
      await _auth.signOut();
      return 'success';
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }
}
