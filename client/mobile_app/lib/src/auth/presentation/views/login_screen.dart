import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/src/auth/presentation/views/register_screen.dart';
import 'package:ecomly/src/auth/presentation/widgets/login_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const path = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyles.headingSemiBold,
        ),
        bottom: const AppBarBottom(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              children: [
                Text(
                  'Hello!!',
                  style: TextStyles.headingBold3.adaptiveColour(context),
                ),
                Text(
                  'Sign in with your account details',
                  style: TextStyles.paragraphSubTextRegular1.grey,
                ),
                const Gap(40),
                const LoginForm(),
              ],
            ),
          ),
          const Gap(8),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              style: TextStyles.paragraphSubTextRegular3.grey,
              children: [
                TextSpan(
                  text: 'Create Account',
                  style:
                      const TextStyle(color: Colours.lightThemePrimaryColour),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.go(RegisterScreen.path);
                    },
                ),
              ],
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }
}
