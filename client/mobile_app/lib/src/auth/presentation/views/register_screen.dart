import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/src/auth/presentation/views/login_screen.dart';
import 'package:ecomly/src/auth/presentation/widgets/registration_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static const path = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
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
                  'Create an Account',
                  style: TextStyles.headingBold3.adaptiveColour(context),
                ),
                Text(
                  'Create a new Ecomly account',
                  style: TextStyles.paragraphSubTextRegular1.grey,
                ),
                const Gap(40),
                const RegistrationForm(),
              ],
            ),
          ),
          const Gap(8),
          RichText(
            text: TextSpan(
              text: "Already have an account? ",
              style: TextStyles.paragraphSubTextRegular3.grey,
              children: [
                TextSpan(
                  text: 'Sign In',
                  style:
                      const TextStyle(color: Colours.lightThemePrimaryColour),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.go(LoginScreen.path);
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
