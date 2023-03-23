import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../responsive/responsive.dart';
import '../../utils/colors.dart';
import '../../utils/global_variables.dart';
import '../../utils/utils.dart';
import '../../widgets/text_field_input.dart';
import '../screens.dart';
import 'login_provider.dart';
import 'login_state.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<LoginState>(loginNotifierProvider, (_, state) {
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
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : const EdgeInsets.symmetric(horizontal: 32),
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
            TextFieldInput(
              hintText: 'Enter your email',
              textInputType: TextInputType.emailAddress,
              onChanged: ref.read(loginNotifierProvider.notifier).emailChanged,
              onFieldSubmitted: ref.read(loginNotifierProvider.notifier).logIn,
            ),
            const SizedBox(height: 24),
            TextFieldInput(
              hintText: 'Enter your password',
              textInputType: TextInputType.text,
              isPass: ref.watch(
                  loginNotifierProvider.select((state) => state.isObsecure)),
              suffixIcon: IconButton(
                icon: Icon(
                  ref.watch(loginNotifierProvider
                          .select((state) => state.isObsecure))
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed:
                    ref.read(loginNotifierProvider.notifier).obsecureChanged,
              ),
              onChanged:
                  ref.read(loginNotifierProvider.notifier).passwordChanged,
              onFieldSubmitted: ref.read(loginNotifierProvider.notifier).logIn,
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: ref.read(loginNotifierProvider.notifier).logIn,
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
                child: ref.watch(loginNotifierProvider
                        .select((state) => state.status.isSubmitting))
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text('Log in'),
              ),
            ),
            const SizedBox(height: 12),
            const Spacer(flex: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  ),
                  child: const Text(
                    'Sign up',
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
