import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import 'auth_state.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    ref.watch(authRepositoryProvider).user.listen((authUser) {
      if (authUser != null) {
        ref
            .watch(userRepositoryProvider)
            .getUserStream(authUser.uid)
            .listen((user) {
          try {
            state = AuthState.authenticated(authUser: authUser, user: user);
          } catch (e) {
            state = AuthState.error(e.toString());
          }
        });
      } else {
        try {
          state = const AuthState.unauthenticated();
        } catch (e) {
          state = AuthState.error(e.toString());
        }
      }
    });
    return const AuthState.loading();
  }

  Future<void> logout() async {
    try {
      await ref.watch(authRepositoryProvider).signOut();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}
