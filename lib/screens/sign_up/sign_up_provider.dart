import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/user.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';
import '../../resources/storage_methods.dart';
import '../../utils/global_variables.dart';
import '../../utils/utils.dart';
import 'sign_up_state.dart';

part 'sign_up_provider.g.dart';

@riverpod
class SignUp extends _$SignUp {
  @override
  SignUpState build() => const SignUpState();

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

  void usernameChanged(String username) {
    state = state.copyWith(
      username: username,
      status: Status.initial,
    );
  }

  void bioChanged(String bio) {
    state = state.copyWith(
      bio: bio,
      status: Status.initial,
    );
  }

  Future<void> selectImage() async {
    final image = await pickImage(ImageSource.gallery);
    state = state.copyWith(
      image: image,
      status: Status.initial,
    );
  }

  void obsecureChanged() {
    state = state.copyWith(
      isObsecure: !state.isObsecure,
      status: Status.initial,
    );
  }

  Future<void> signUp() async {
    if (state.image == null) {
      state = state.copyWith(
        status: Status.error,
        errorMessage: 'No Image Selected',
      );
      return;
    }
    if (state.status == Status.submitting) return;
    state = state.copyWith(status: Status.submitting);
    try {
      final authUser = await ref.read(authRepositoryProvider).signUp(
            email: state.email,
            password: state.password,
          );
      final photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', state.image!, false, '');
      final user = User(
        uid: authUser!.uid,
        username: state.username,
        photoUrl: photoUrl,
        email: state.email,
        bio: state.bio,
      );
      await ref.read(userRepositoryProvider).createUser(user);
      state = state.copyWith(status: Status.success);
    } catch (e) {
      state = state.copyWith(
        status: Status.error,
        errorMessage: e.toString(),
      );
    }
  }
}
