import 'package:buyghana/core/extensions/text_style_extensions.dart';
import 'package:buyghana/core/res/media.dart';
import 'package:buyghana/core/res/styles/colours.dart';
import 'package:buyghana/core/res/styles/text.dart';
import 'package:buyghana/src/auth/presentation/views/login_screen.dart';
import 'package:buyghana/src/auth/presentation/widgets/registration_form.dart';
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
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(LoginScreen.path);
          },
        ),
        title: Text('Register',
            style: TextStyles.headingBold1.adaptiveColour(context)),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              children: [
                Text(
                  'Getting Started',
                  // textAlign: TextAlign.center,
                  style: TextStyles.headingBold3.adaptiveColour(context),
                ),
                Text(
                  "Let's create you an account",
                  // textAlign: TextAlign.center,
                  style: TextStyles.paragraphSubTextRegular1.grey,
                ),
                const Gap(20),
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
