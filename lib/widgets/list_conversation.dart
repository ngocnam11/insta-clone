import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';
import '../providers/message_provider.dart';
import '../screens/conversation_screen.dart';
import 'custom_network_image.dart';

class ListConversation extends ConsumerWidget {
  const ListConversation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discussionUserValue = ref.watch(getDiscussionUserProvider);

    return discussionUserValue.when(
      data: (discussionList) => discussionList.isEmpty
          ? const Center(child: Text('No discussion'))
          : ListView.separated(
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: discussionList.length,
              itemBuilder: (context, index) => ConversationItem(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ConversationScreen(
                        user: discussionList[index],
                      ),
                    ),
                  );
                },
                user: discussionList[index],
              ),
              separatorBuilder: (context, index) => const Divider(indent: 80),
            ),
      error: (error, stackTrace) {
        debugPrint(error.toString());
        return const Text('Something went wrong');
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class ConversationItem extends ConsumerWidget {
  const ConversationItem({super.key, required this.onTap, required this.user});

  final VoidCallback onTap;
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myMessageValue = ref.watch(myMessageProvider(uid: user.uid));
    final otherMessageValue = ref.watch(otherMessageProvider(uid: user.uid));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Ink(
        height: 80,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: CustomNetworkImage(
                  src: user.photoUrl,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              myMessageValue.maybeWhen(
                data: (myMessages) => otherMessageValue.maybeWhen(
                  data: (otherMessages) {
                    var messages = [...myMessages, ...otherMessages];
                    messages.sort((i, j) => i.createAt!.compareTo(j.createAt!));
                    messages = messages.reversed.toList();
                    return Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.username,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                Text(
                                  messages.isEmpty
                                      ? 'No message'
                                      : messages[0].content!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            messages.isEmpty
                                ? ''
                                : DateFormat('dd-MM-yy')
                                    .format(messages[0].createAt!.toDate()),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  },
                  orElse: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                orElse: () => const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
