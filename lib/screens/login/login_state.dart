import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/global_variables.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String email,
    @Default('') String password,
    @Default(true) bool isObsecure,
    @Default(Status.initial) Status status,
    @Default('') String errorMessage,
  }) = _LoginState;
}
