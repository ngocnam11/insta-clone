class User {
  final String uid;
  final String email;
  final String username;
  final String photoUrl;
  final String bio;
  final List<String> followers;
  final List<String> following;

  const User({
    required this.uid,
    required this.email,
    required this.username,
    required this.photoUrl,
    this.bio = '',
    this.followers = const [],
    this.following = const [],
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
        'bio': bio,
        'followers': followers,
        'following': following,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    List<String> followers = [];
    if (json['followers'] != null) {
      json['followers'].forEach((follower) {
        followers.add(follower);
      });
    }
    List<String> following = [];
    if (json['following'] != null) {
      json['following'].forEach((follow) {
        following.add(follow);
      });
    }

    return User(
      username: json['username'],
      uid: json['uid'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      bio: json['bio'],
      followers: followers,
      following: following,
    );
  }

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, username: $username, photoUrl: $photoUrl, bio: $bio, followers: $followers, following: $following)';
  }
}
