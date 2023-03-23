import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String postId;
  final String username;
  final String description;
  final Timestamp datePublished;
  final String postUrl;
  final String profImage;
  final List<String> likes;

  Post({
    required this.uid,
    required this.username,
    required this.postId,
    required this.description,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    this.likes = const [],
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'postId': postId,
        'description': description,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'likes' : List<dynamic>.from(likes.map((e) => e)),
      };

  factory Post.fromJson(Map<String, dynamic> json) {
    List<String> likes = [];
    if (json['likes'] != null) {
      json['likes'].forEach((like) {
        likes.add(like);
      });
    }

    return Post(
      uid: json['uid'],
      username: json['username'],
      postId: json['postId'],
      description: json['description'],
      datePublished: json['datePublished'], 
      postUrl: json['postUrl'],
      profImage: json['profImage'],
      likes: likes,
    );
  }
}
