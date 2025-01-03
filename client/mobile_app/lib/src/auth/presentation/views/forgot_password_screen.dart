import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/src/auth/presentation/widgets/forgot_password_form.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  static const path = '/forgot-password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyles.headingSemiBold,
        ),
        bottom: const AppBarBottom(),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        children: [
          Text(
            'Confirm Email',
            style: TextStyles.headingBold3.adaptiveColour(context),
          ),
          Text(
            'Enter the email address associated with your account',
            style: TextStyles.paragraphSubTextRegular1.grey,
          ),
          const Gap(40),
          const ForgotPasswordForm(),
        ],
      ),
    );
  }
}
