import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/global_variables.dart';

part 'sign_up_state.freezed.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState({
    @Default('') String email,
    @Default('') String password,
    @Default('') String username,
    @Default('') String bio,
    Uint8List? image,
    @Default(true) bool isObsecure,
    @Default(Status.initial) Status status,
    @Default('') String errorMessage,
  }) = _SignUpState;
}
