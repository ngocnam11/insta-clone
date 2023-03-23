import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/user.dart';
import '../providers/message_provider.dart';
import '../widgets/message_component.dart';
import '../widgets/text_field_input.dart';

class ConversationScreen extends HookConsumerWidget {
  const ConversationScreen({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final msgController = useTextEditingController();

    final myMessageValue = ref.watch(myMessageProvider(uid: user.uid));
    final otherMessageValue = ref.watch(otherMessageProvider(uid: user.uid));

    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: myMessageValue.maybeWhen(
                data: (myMessages) => otherMessageValue.maybeWhen(
                  data: (otherMessages) {
                    var messages = [...myMessages, ...otherMessages];
                    messages.sort((i, j) => i.createAt!.compareTo(j.createAt!));
                    messages = messages.reversed.toList();
                    return messages.isEmpty
                        ? const Center(child: Text('No message'))
                        : ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: messages.length,
                            itemBuilder: ((context, index) {
                              final msg = messages[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: MessageComponent(message: msg),
                              );
                            }),
                          );
                  },
                  orElse: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                orElse: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFieldInput(
                    controller: msgController,
                    hintText: 'Aa',
                    textInputType: TextInputType.multiline,
                    // maxLines: 8,
                    // contentPadding: const EdgeInsets.all(12),
                    // textInputAction: TextInputAction.newline,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (await ref.read(sendMessageProvider(
                      content: msgController.text,
                      reciverUID: user.uid,
                    ).future)) msgController.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
