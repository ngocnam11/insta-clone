import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/user.dart';
import '../repositories/user_repository.dart';
import 'text_field_input.dart';

class ListFollow extends ConsumerStatefulWidget {
  const ListFollow({
    super.key,
    required this.title,
    required this.follower,
  });

  final String title;
  final List<String> follower;

  @override
  ConsumerState<ListFollow> createState() => _ListFollowState();
}

class _ListFollowState extends ConsumerState<ListFollow> {
  final TextEditingController searchController = TextEditingController();
  List<User> listUsers = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      for (var follow in widget.follower) {
        final user =
            await ref.read(userRepositoryProvider).fetchUser(uid: follow);
        listUsers.add(user!);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          TextFieldInput(
            controller: searchController,
            hintText: 'Search',
            textInputType: TextInputType.text,
          ),
          const SizedBox(height: 8),
          Text(widget.title),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            itemCount: listUsers.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 24,
                    foregroundImage: NetworkImage(listUsers[index].photoUrl),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      Text(
                        listUsers[index].username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Text('fullname'),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
          )
        ],
      ),
    );
  }
}
