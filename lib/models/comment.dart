import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentId;
  final String uid;
  final String postId;
  final Timestamp createAt;
  final String content;
  final List<Comment> replies;
  final List<String> likes;

  Comment({
    required this.commentId,
    required this.uid,
    required this.postId,
    required this.createAt,
    required this.content,
    this.replies = const <Comment>[],
    this.likes = const [],
  });

  Map<String, dynamic> toJson() => {
        'commentId': commentId,
        'uid': uid,
        'postId': postId,
        'createAt': createAt,
        'content': content,
        'replies': List<dynamic>.from(replies.map((reply) => reply.toJson())),
        'likes': List<dynamic>.from(likes.map((e) => e)),
      };

  factory Comment.fromJson(Map<String, dynamic> json) {
    List<Comment> replies = [];
    if (json['replies'] != null) {
      json['replies'].forEach((reply) {
        replies.add(Comment.fromJson(reply));
      });
    }
    List<String> likes = [];
    if (json['likes'] != null) {
      json['likes'].forEach((like) {
        likes.add(like);
      });
    }

    return Comment(
      commentId: json['commentId'],
      uid: json['uid'],
      postId: json['postId'],
      createAt: json['createAt'],
      content: json['content'],
      replies: replies,
      likes: likes,
    );
  }
}
