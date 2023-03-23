import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:intl/intl.dart';

import '../models/post.dart';
import '../resources/firestore_methods.dart';
import '../screens/screens.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
import 'like_animation.dart';
import 'options_button.dart';

class PostCard extends ConsumerStatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool isLikeAnimating = false;
  int commentTotal = 0;
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final comments = ref
          .read(fireStoreMethodsProvider)
          .getComments(postId: widget.post.postId);
      comments.forEach(
        (comment) {
          for (var e in comment) {
            commentTotal += e.replies.length;
          }
          commentTotal += comment.length;
        },
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final user = ref.watch(userModelProvider);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    widget.post.profImage,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                OptionsButton(widget.post),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await ref.read(fireStoreMethodsProvider).likePost(
                    widget.post.postId,
                    user!.uid,
                    widget.post.likes,
                  );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  widget.post.postUrl,
                  fit: BoxFit.fitWidth,
                ),
                AnimatedOpacity(
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.post.likes.contains(user!.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await ref.read(fireStoreMethodsProvider).likePost(
                          widget.post.postId,
                          user.uid,
                          widget.post.likes,
                        );
                  },
                  icon: widget.post.likes.contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        post: widget.post,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: widget.post.likes.isEmpty ? false : true,
                  child: Text(
                    '${widget.post.likes.length} likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(widget.post.username),
                    const SizedBox(width: 8),
                    Text(widget.post.description),
                  ],
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          post: widget.post,
                        ),
                      ),
                    );
                  },
                  child: Visibility(
                    visible: commentTotal == 0 ? false : true,
                    child: Text(
                      'View all $commentTotal comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat.yMMMd().format(
                    widget.post.datePublished.toDate(),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
