import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/message.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/global_variables.dart';

part 'message_repository.g.dart';

@Riverpod(keepAlive: true)
MessageRepository messageRepository(MessageRepositoryRef ref) {
  return MessageRepository._(FirebaseFirestore.instance, ref);
}

class MessageRepository {
  final FirebaseFirestore _firestore;
  final MessageRepositoryRef _ref;

  const MessageRepository._(this._firestore, this._ref);

  Stream<List<User>> get getDiscussionUser {
    return _firestore
        .collection('users')
        .where('uid', isNotEqualTo: _ref.read(userModelProvider)?.uid)
        .snapshots()
        .map(
            (event) => event.docs.map((e) => User.fromJson(e.data())).toList());
  }

  Stream<List<Message>> getMessage(String reciverUID, [bool myMessage = true]) {
    return _firestore
        .collection('messages')
        .where('senderUID',
            isEqualTo:
                myMessage ? _ref.read(userModelProvider)?.uid : reciverUID)
        .where('reciverUID',
            isEqualTo:
                myMessage ? reciverUID : _ref.read(userModelProvider)?.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Message.fromJson(e.data(), e.id)).toList());
  }

  Future<bool> sendMessage(Message msg) async {
    try {
      await _firestore.collection('messages').doc().set(msg.toJson());
      return true;
    } catch (e) {
      log.e(e.toString());
      return false;
    }
  }
}
