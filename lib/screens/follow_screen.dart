import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/list_follow.dart';

class FollowScreen extends StatelessWidget {
  const FollowScreen({super.key, required this.tab, required this.follow});
  final int tab;
  final User follow;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: tab,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(follow.username),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Follower: ${follow.followers.length}'),
              Tab(text: 'Following: ${follow.following.length}'),
              const Tab(text: '0 Package '),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListFollow(
              title: 'All follower',
              follower: follow.followers,
            ),
            ListFollow(
              title: 'All following',
              follower: follow.following,
            ),
            const Text(
              'Dang ky xem noi dung cua nguoi sang tao ma ban theo doi',
            ),
          ],
        ),
      ),
    );
  }
}
