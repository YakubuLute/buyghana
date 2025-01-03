import 'package:ecomly/core/common/widgets/rounded_button.dart';
import 'package:ecomly/core/common/widgets/vertical_label_field.dart';
import 'package:ecomly/core/extensions/widget_extensions.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/auth/presentation/app/riverpod/auth_provider.dart';
import 'package:ecomly/src/auth/presentation/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordForm extends ConsumerStatefulWidget {
  const ResetPasswordForm({required this.email, super.key});

  final String email;

  @override
  ConsumerState<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends ConsumerState<ResetPasswordForm> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final obscurePasswordNotifier = ValueNotifier(true);
  final obscureConfirmPasswordNotifier = ValueNotifier(true);

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    obscurePasswordNotifier.dispose();
    obscureConfirmPasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider());
    ref.listen(authProvider(), (previous, next) {
      if (next is AuthError) {
        CoreUtils.showSnackBar(context, message: next.message);
      } else if (next is PasswordReset) {
        CoreUtils.postFrameCall(
          () => context.go(Uri(path: LoginScreen.path).toString()),
        );
      }
    });
    return Form(
      key: formKey,
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: obscurePasswordNotifier,
            builder: (_, value, __) {
              return VerticalLabelField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscurePasswordNotifier.value =
                        !obscurePasswordNotifier.value;
                  },
                  child: Icon(
                    value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
                obscureText: value,
              );
            },
          ),
          const Gap(20),
          ValueListenableBuilder(
            valueListenable: obscureConfirmPasswordNotifier,
            builder: (_, value, __) {
              return VerticalLabelField(
                label: 'Confirm Password',
                hintText: 'Re-enter your password',
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscureConfirmPasswordNotifier.value =
                        !obscureConfirmPasswordNotifier.value;
                  },
                  child: Icon(
                    value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
                obscureText: value,
                validator: (value) {
                  if (value! != passwordController.text.trim()) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              );
            },
          ),
          const Gap(40),
          RoundedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final password = passwordController.text.trim();
                await ref.read(authProvider().notifier).resetPassword(
                      email: widget.email,
                      newPassword: password,
                    );
              }
            },
            text: 'Submit',
          ).loading(auth is AuthLoading),
        ],
      ),
    );
  }
}
