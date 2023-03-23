import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user.dart';
import 'auth_provider.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
User? userModel(UserModelRef ref) {
  return ref.watch(authNotifierProvider).maybeMap(
        authenticated: (value) => value.user,
        orElse: () => null,
      );
}
