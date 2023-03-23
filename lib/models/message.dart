import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

@freezed
class Message with _$Message {
  const Message._();

  const factory Message({
    String? id,
    String? content,
    String? senderUID,
    String? reciverUID,
    Timestamp? createAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json, String id) {
    return Message(
      id: id,
      content: json['content'],
      senderUID: json['senderUID'],
      reciverUID: json['reciverUID'],
      createAt: json['createAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderUID': senderUID,
      'reciverUID': reciverUID,
      'createAt': createAt,
    };
  }
}
