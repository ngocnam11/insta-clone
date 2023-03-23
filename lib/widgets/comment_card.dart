import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:instagram_flutter/models/comment.dart';

import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../screens/comments_screen.dart';

final commentIdProvider = StateProvider<String>((ref) => '');
final visibleRepliesProvider = StateProvider<bool>((ref) => false);

class CommentCard extends ConsumerStatefulWidget {
  final Comment comment;
  const CommentCard({super.key, required this.comment});

  @override
  ConsumerState<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends ConsumerState<CommentCard> {
  User user = const User(uid: '', email: '', username: '', photoUrl: '');

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final userDetails =
          await ref.read(userRepositoryProvider).fetchUser(uid: widget.comment.uid);
      user = userDetails!;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                user.photoUrl,
              ),
              radius: 18,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(user.username),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat.yMMMd()
                          .format(widget.comment.createAt.toDate()),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(widget.comment.content),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () {
                    ref
                        .read(commentTypeProvider.notifier)
                        .update((state) => CommentType.reply);
                    ref
                        .read(commentIdProvider.notifier)
                        .update((state) => widget.comment.commentId);
                  },
                  child: const Text('Reply'),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.favorite_outline_outlined,
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: 8),
        widget.comment.replies.isEmpty
            ? const SizedBox()
            : Visibility(
                visible: widget.comment.replies.length >= 2
                    ? ref.read(visibleRepliesProvider)
                    : true,
                replacement: Padding(
                  padding: const EdgeInsets.only(left: 56),
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(visibleRepliesProvider.notifier)
                          .update((state) => true);
                      setState(() {});
                    },
                    child: Text(
                      '-------- See ${widget.comment.replies.length} replies',
                    ),
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 56, bottom: 8),
                  itemCount: widget.comment.replies.length,
                  itemBuilder: (context, index) =>
                      CommentCard(comment: widget.comment.replies[index]),
                ),
              )
      ],
    );
  }
}
