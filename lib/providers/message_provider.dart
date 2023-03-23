import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/message.dart';
import '../models/user.dart';
import '../repositories/message_repository.dart';
import 'user_provider.dart';

part 'message_provider.g.dart';

@riverpod
Future<bool> sendMessage(
  SendMessageRef ref, {
  required String content,
  required String reciverUID,
}) {
  final message = Message(
    content: content,
    senderUID: ref.read(userModelProvider)?.uid,
    reciverUID: reciverUID,
    createAt: Timestamp.now(),
  );
  return ref.read(messageRepositoryProvider).sendMessage(message);
}

@riverpod
Stream<List<Message>> myMessage(MyMessageRef ref, {required String uid}) {
  return ref.read(messageRepositoryProvider).getMessage(uid);
}

@riverpod
Stream<List<Message>> otherMessage(OtherMessageRef ref, {required String uid}) {
  return ref.read(messageRepositoryProvider).getMessage(uid, false);
}

@riverpod
Stream<List<User>> getDiscussionUser(GetDiscussionUserRef ref) {
  return ref.read(messageRepositoryProvider).getDiscussionUser;
}
