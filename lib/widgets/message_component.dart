import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/message.dart';
import '../providers/user_provider.dart';

class MessageComponent extends ConsumerWidget {
  const MessageComponent({super.key, this.message});
  final Message? message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    var date = message!.createAt!.toDate().toLocal();
    final isMe = message?.senderUID == ref.watch(userModelProvider)?.uid;

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              constraints: BoxConstraints(
                minHeight: 40,
                minWidth: 30,
                maxWidth: width * 0.7,
              ),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: isMe
                      ? const Radius.circular(10)
                      : const Radius.circular(0),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(10),
                ),
              ),
              child: Text(
                message!.content!,
                style: isMe
                    ? Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white)
                    : Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.black),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(
                  right: 5,
                  bottom: 5,
                ),
                child: Text(
                  '${date.hour}h${date.minute}',
                  style: isMe
                      ? const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        )
                      : const TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
