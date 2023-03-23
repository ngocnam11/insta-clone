import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/global_variables.dart';
import 'mobile_screen_layout.dart';
import 'web_screen_layout.dart';

class ResponsiveLayout extends ConsumerWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          return const WebScreenLayout();
        }
        return const MobileScreenLayout();
      },
    );
  }
}
