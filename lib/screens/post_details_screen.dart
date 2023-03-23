import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/post.dart';
import '../utils/colors.dart';
import '../widgets/post_card.dart';

class PostDetailsScreen extends ConsumerWidget {
  const PostDetailsScreen(this.post, {super.key});
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Post Details'),
      ),
      body: SingleChildScrollView(
        child: PostCard(post: post),
      ),
    );
  }
}
