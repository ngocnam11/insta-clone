import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';
import '../providers/user_provider.dart';
import '../repositories/user_repository.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import '../widgets/follow_button.dart';
import '../widgets/start_column.dart';
import 'screens.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  User user = const User(uid: '', email: '', username: '', photoUrl: '');

  void navigateToFollowScreen(int tab) async {
    final user =
        await ref.read(userRepositoryProvider).fetchUser(uid: widget.uid);
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FollowScreen(
          tab: tab,
          follow: user!,
        ),
      ),
    );
  }

  void _followUser() async {
    await ref.read(userRepositoryProvider).followUser(
          ref.read(userModelProvider)!.uid,
          widget.uid,
        );
    final userDetails =
        await ref.read(userRepositoryProvider).fetchUser(uid: widget.uid);
    user = userDetails!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final userDetails =
          await ref.read(userRepositoryProvider).fetchUser(uid: widget.uid);
      user = userDetails!;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      state.whenOrNull(
        unauthenticated: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        ),
        error: (message) => showSnackBar(context, message),
      );
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          user.username,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(user.photoUrl),
                    radius: 44,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const StartColumn(
                              count: 0,
                              label: 'posts',
                            ),
                            StartColumn(
                              count: user.followers.length,
                              label: 'followers',
                              onTap: () => navigateToFollowScreen(0),
                            ),
                            StartColumn(
                              count: user.following.length,
                              label: 'following',
                              onTap: () => navigateToFollowScreen(1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ref.watch(userModelProvider)!.uid == widget.uid
                                ? FollowButton(
                                    backgroundColor: mobileBackgroundColor,
                                    borderColor: Colors.grey,
                                    text: 'Sign out',
                                    textColor: Colors.white,
                                    function: () async => await ref
                                        .read(authNotifierProvider.notifier)
                                        .logout(),
                                  )
                                : user.followers.contains(
                                        ref.watch(userModelProvider)!.uid)
                                    ? FollowButton(
                                        backgroundColor: Colors.white,
                                        borderColor: Colors.grey,
                                        text: 'Unfollow',
                                        textColor: Colors.black,
                                        function: () => _followUser(),
                                      )
                                    : FollowButton(
                                        backgroundColor: Colors.blue,
                                        borderColor: Colors.blue,
                                        text: 'Follow',
                                        textColor: Colors.white,
                                        function: () => _followUser(),
                                      ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                user.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(user.bio),
            ],
          ),
          const Divider(),
          StreamBuilder<List<Post>>(
            stream: ref
                .read(fireStoreMethodsProvider)
                .getPostsOfUser(uid: widget.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                log.e(snapshot.error.toString());
                return const Text('Some error occurred');
              }
              return GridView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PostDetailsScreen(
                            snapshot.data![index],
                          ),
                        ),
                      );
                    },
                    child: Image(
                      image: NetworkImage(
                        snapshot.data![index].postUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
