import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/comment.dart';
import '../models/post.dart';
import '../utils/global_variables.dart';
import 'storage_methods.dart';

final fireStoreMethodsProvider = Provider<FireStoreMethods>((ref) {
  return FireStoreMethods._(ref);
});

class FireStoreMethods {
  FireStoreMethods._(this._ref);
  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storage = StorageMethods();

  Stream<List<Post>> getPosts() {
    final snaps = _firestore.collection('posts').snapshots();
    final posts = snaps.map(
        (snap) => snap.docs.map((doc) => Post.fromJson(doc.data())).toList());
    return posts;
  }

  Stream<List<Comment>> getComments({required String postId}) {
    final snaps = _firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .snapshots();
    final comments = snaps.map((snap) =>
        snap.docs.map((doc) => Comment.fromJson(doc.data())).toList());
    return comments;
  }

  // Stream<Comment> getCommentDetails({required String commentId}) {
  //   final snap = _firestore.collection('comments').doc(commentId).snapshots();
  //   return snap.map((e) => Comment.fromJson(e.data()!));
  // }

  Stream<List<Post>> getPostsOfUser({required String uid}) {
    final snaps =
        _firestore.collection('posts').where('uid', isEqualTo: uid).snapshots();
    final posts = snaps.map(
        (snap) => snap.docs.map((doc) => Post.fromJson(doc.data())).toList());
    return posts;
  }

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = 'some error occurred';
    try {
      String postId = const Uuid().v1();
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true, postId);
      
      Post post = Post(
        uid: uid,
        postId: postId,
        username: username,
        description: description,
        datePublished: Timestamp.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      log.e(e.toString());
    }
  }

  Future<String> commentToPost({
    required String uid,
    required String postId,
    required String content,
  }) async {
    String res = 'Some error occurred';
    try {
      if (content.isNotEmpty) {
        String commentId = const Uuid().v1();
        Comment comment = Comment(
          commentId: commentId,
          uid: uid,
          postId: postId,
          createAt: Timestamp.now(),
          content: content,
          replies: [],
          likes: [],
        );
        _firestore.collection('comments').doc(commentId).set(comment.toJson());
      } else {
        log.e('Text is empty');
      }
      res = 'success';
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  Future<void> replyComment(
    String commentId,
    String uid,
    String postId,
    String replyContent,
  ) async {
    try {
      if (replyContent.isNotEmpty) {
        String replyId = const Uuid().v1();
        Comment reply = Comment(
          commentId: replyId,
          uid: uid,
          postId: postId,
          createAt: Timestamp.now(),
          content: replyContent,
          replies: [],
          likes: [],
        );
        _firestore.collection('comments').doc(commentId).update({
          'replies': FieldValue.arrayUnion([reply.toJson()])
        });
      } else {
        log.e('Text is empty');
      }
    } catch (e) {
      log.e(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _storage.deleteImageFromStorage('posts', true, postId);
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      log.e(err.toString());
    }
  }
}
