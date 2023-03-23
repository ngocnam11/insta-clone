import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/post.dart';
import '../providers/user_provider.dart';
import '../repositories/user_repository.dart';
import '../resources/firestore_methods.dart';

class OptionsButton extends ConsumerWidget {
  const OptionsButton(this.post, {super.key});
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          builder: (BuildContext context) {
            return SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        OptionColumn(
                          title: 'Share',
                          icon: Icons.share_outlined,
                        ),
                        OptionColumn(
                          title: 'Link',
                          icon: Icons.link,
                        ),
                        OptionColumn(
                          title: 'Save',
                          icon: Icons.bookmark_border,
                        ),
                      ],
                    ),
                    const Divider(),
                    const OptionRow(
                      title: 'Add to favorites',
                      icon: Icons.star_border_outlined,
                    ),
                    ref.read(userModelProvider)!.uid != post.uid
                        ? OptionRow(
                            title: ref
                                    .read(userModelProvider)!
                                    .following
                                    .contains(post.uid)
                                ? 'Unfollow'
                                : 'Follow',
                            icon: ref
                                    .read(userModelProvider)!
                                    .following
                                    .contains(post.uid)
                                ? Icons.person_remove_outlined
                                : Icons.person_add_alt,
                            onTap: () {
                              ref.read(userRepositoryProvider).followUser(
                                  ref.read(userModelProvider)!.uid, post.uid);
                              Navigator.of(context).pop();
                            },
                          )
                        : OptionRow(
                            title: 'Delete',
                            icon: Icons.delete_outline,
                            onTap: () {
                              ref
                                  .read(fireStoreMethodsProvider)
                                  .deletePost(post.postId);
                              Navigator.of(context).pop();
                            }),
                    const Divider(),
                    const OptionRow(
                      title: 'Why did you see this post',
                      icon: Icons.info_outline,
                    ),
                    const OptionRow(
                      title: 'Hide this post',
                      icon: Icons.hide_image_outlined,
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.report_outlined,
                          color: Colors.red,
                          size: 32,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Report',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.more_vert),
    );
  }
}

class OptionColumn extends StatelessWidget {
  const OptionColumn({
    super.key,
    required this.title,
    this.onTap,
    required this.icon,
  });
  final String title;
  final Function()? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            child: Icon(
              icon,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }
}

class OptionRow extends StatelessWidget {
  const OptionRow({
    super.key,
    required this.title,
    this.onTap,
    required this.icon,
  });
  final String title;
  final Function()? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
