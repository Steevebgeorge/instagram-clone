import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/postmodel.dart';
import 'package:instagram/services/storage.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    Uint8List file,
    String description,
    String uid,
    String userName,
    String profileImage,
  ) async {
    String res = 'some error occured';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('Posts', file, true);
      String postId = const Uuid().v1();
      PostModel post = PostModel(
          description: description,
          uid: uid,
          userName: userName,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profileImage: profileImage,
          likes: []);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profileImage) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profileImage,
          'name': name,
          'text': text,
          'uid': uid,
          'date': DateTime.now(),
          'commentId': commentId
        });
      } else {}
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        _firestore.collection('users').doc(followId).update(
          {
            'followers': FieldValue.arrayRemove([uid])
          },
        );

        _firestore.collection('users').doc(uid).update(
          {
            'following': FieldValue.arrayRemove([followId])
          },
        );
      } else {
        _firestore.collection('users').doc(followId).update(
          {
            'followers': FieldValue.arrayUnion([uid])
          },
        );

        _firestore.collection('users').doc(uid).update(
          {
            'following': FieldValue.arrayUnion([followId])
          },
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
