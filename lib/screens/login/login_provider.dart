import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/auth_repository.dart';
import '../../utils/global_variables.dart';
import 'login_state.dart';

part 'login_provider.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() => const LoginState();

  void emailChanged(String email) {
    state = state.copyWith(
      email: email,
      status: Status.initial,
    );
  }

  void passwordChanged(String password) {
    state = state.copyWith(
      password: password,
      status: Status.initial,
    );
  }

  void obsecureChanged() {
    state = state.copyWith(
      isObsecure: !state.isObsecure,
      status: Status.initial,
    );
  }

  Future<void> logIn([_]) async {
    if (state.email.isEmpty || state.password.isEmpty) return;
    if (state.status == Status.submitting) return;
    state = state.copyWith(status: Status.submitting);
    try {
      await ref.read(authRepositoryProvider).logIn(
            email: state.email,
            password: state.password,
          );
      state = state.copyWith(status: Status.success);
    } catch (e) {
      state = state.copyWith(
        status: Status.error,
        errorMessage: e.toString(),
      );
    }
  }
}
