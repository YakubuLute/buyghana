import 'package:ecomly/core/common/widgets/rounded_button.dart';
import 'package:ecomly/core/common/widgets/vertical_label_field.dart';
import 'package:ecomly/core/extensions/widget_extensions.dart';
import 'package:ecomly/core/services/router.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/auth/presentation/app/riverpod/auth_provider.dart';
import 'package:ecomly/src/auth/presentation/views/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordForm extends ConsumerStatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  ConsumerState<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends ConsumerState<ForgotPasswordForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider());
    debugPrint(router.routerDelegate.currentConfiguration.toString());
    ref.listen(authProvider(), (previous, next) {
      if (next is AuthError) {
        CoreUtils.showSnackBar(context, message: next.message);
      } else if (next is OTPSent) {
        context.push(
          VerifyOTPScreen.path,
          extra: emailController.text.trim(),
        );
      }
    });
    return Form(
      key: formKey,
      child: Column(
        children: [
          VerticalLabelField(
            label: 'Email',
            hintText: 'Enter your email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const Gap(40),
          RoundedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await ref.read(authProvider().notifier).forgotPassword(
                      email: emailController.text.trim(),
                    );
              }
            },
            text: 'Continue',
          ).loading(auth is AuthLoading),
        ],
      ),
    );
  }
}
