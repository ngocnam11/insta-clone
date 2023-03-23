import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user.dart';
import '../utils/global_variables.dart';

part 'user_repository.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository._(FirebaseFirestore.instance);
}

class UserRepository {
  final FirebaseFirestore _firestore;
  const UserRepository._(this._firestore);

  Future<void> createUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } catch (_) {
      rethrow;
    }
  }

  Stream<User> getUserStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => User.fromJson(snap.data()!));
  }

  Future<User?> fetchUser({required String uid}) async {
    try {
      final snap = await _firestore.collection('users').doc(uid).get();
      if (snap.exists) return User.fromJson(snap.data()!);
      return null;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toJson());
    } catch (_) {
      rethrow;
    }
  }

  Stream<List<User>> searchUser({required String username}) {
    final snaps = _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: username)
        .snapshots();
    final listUser = snaps.map(
        (snap) => snap.docs.map((doc) => User.fromJson(doc.data())).toList());
    return listUser;
  }

  Future<void> followUser(
    String uid,
    String followId,
  ) async {
    try {
      final snap = await _firestore.collection('users').doc(uid).get();
      final following = snap.data()!['following'] as List;

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      log.e(e.toString());
    }
  }
}
