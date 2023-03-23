import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/list_conversation.dart';
import '../widgets/text_field_input.dart';

class ChatScreen extends HookConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 4,
            ),
            child: TextFieldInput(
              controller: searchController,
              textInputType: TextInputType.text,
              hintText: 'Search user',
            ),
          ),
          const Divider(),
          const Expanded(
            child: ListConversation(),
          ),
        ],
      ),
    );
  }
}
