import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../responsive/responsive.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../../widgets/text_field_input.dart';
import '../screens.dart';
import 'sign_up_provider.dart';
import 'sign_up_state.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SignUpState>(signUpProvider, (_, state) {
      if (state.status.isSuccess) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(),
        ));
      }
      if (state.status.isError) {
        showSnackBar(context, state.errorMessage);
      }
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            SvgPicture.asset(
              'assets/ic_instagram.svg',
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              height: 64,
            ),
            const SizedBox(height: 64),
            Stack(
              children: [
                ref.watch(signUpProvider.select((state) => state.image)) != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(
                          ref.watch(
                              signUpProvider.select((state) => state.image))!,
                        ),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          'https://miro.medium.com/max/640/1*W35QUSvGpcLuxPo3SRTH4w.webp',
                        ),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: ref.read(signUpProvider.notifier).selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            TextFieldInput(
              hintText: 'Enter your username',
              textInputType: TextInputType.text,
              onChanged: ref.read(signUpProvider.notifier).usernameChanged,
            ),
            const SizedBox(height: 24),
            TextFieldInput(
              hintText: 'Enter your email',
              textInputType: TextInputType.emailAddress,
              onChanged: ref.read(signUpProvider.notifier).emailChanged,
            ),
            const SizedBox(height: 24),
            TextFieldInput(
              hintText: 'Enter your password',
              textInputType: TextInputType.text,
              isPass:
                  ref.watch(signUpProvider.select((state) => state.isObsecure)),
              suffixIcon: IconButton(
                icon: Icon(
                  ref.watch(signUpProvider.select((state) => state.isObsecure))
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: ref.read(signUpProvider.notifier).obsecureChanged,
              ),
              onChanged: ref.read(signUpProvider.notifier).passwordChanged,
            ),
            const SizedBox(height: 24),
            TextFieldInput(
              hintText: 'Enter your bio',
              textInputType: TextInputType.text,
              onChanged: ref.read(signUpProvider.notifier).bioChanged,
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: ref.read(signUpProvider.notifier).signUp,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  color: blueColor,
                ),
                child: ref.watch(signUpProvider
                        .select((state) => state.status.isSubmitting))
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text('Sign up'),
              ),
            ),
            const SizedBox(height: 12),
            const Spacer(flex: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Do you have an account?'),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
