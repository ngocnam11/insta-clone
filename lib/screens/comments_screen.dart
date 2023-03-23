import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/comment.dart';
import '../models/post.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/comment_card.dart';

enum CommentType {
  comment,
  reply,
}

final commentTypeProvider = StateProvider<CommentType>(
  (ref) => CommentType.comment,
);

class CommentsScreen extends HookConsumerWidget {
  const CommentsScreen({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController();
    final replyFocus = useFocusNode();
    final user = ref.watch(userModelProvider)!;
    ref.listen<CommentType>(commentTypeProvider, (previous, next) {
      if (next == CommentType.reply) replyFocus.requestFocus();
    });
 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 16),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    post.profImage,
                  ),
                  radius: 18,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(post.username),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat.yMMMd().format(post.datePublished.toDate()),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(post.description),
                    const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
            const Divider(),
            StreamBuilder<List<Comment>>(
              stream: ref
                  .read(fireStoreMethodsProvider)
                  .getComments(postId: post.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) =>
                      CommentCard(comment: snapshot.data![index]),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.only(
          left: 16,
          right: 8,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 8.0,
                ),
                child: TextField(
                  controller: commentController,
                  focusNode: replyFocus,
                  decoration: InputDecoration(
                    hintText: 'Comment as ${user.username}',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (ref.read(commentTypeProvider.notifier).state ==
                    CommentType.comment) {
                  await ref.read(fireStoreMethodsProvider).commentToPost(
                        uid: user.uid,
                        postId: post.postId,
                        content: commentController.text,
                      );
                  commentController.clear();
                } else {
                  await ref.read(fireStoreMethodsProvider).replyComment(
                        ref.read(commentIdProvider),
                        ref.read(userModelProvider)!.uid,
                        post.postId,
                        commentController.text,
                      );
                  commentController.clear();
                  ref
                      .read(commentTypeProvider.notifier)
                      .update((state) => CommentType.comment);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: blueColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
