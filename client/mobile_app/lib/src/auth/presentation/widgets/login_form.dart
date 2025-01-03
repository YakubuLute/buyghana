import 'package:ecomly/core/common/widgets/rounded_button.dart';
import 'package:ecomly/core/common/widgets/vertical_label_field.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/extensions/widget_extensions.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/auth/presentation/app/riverpod/auth_provider.dart';
import 'package:ecomly/src/auth/presentation/views/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePasswordNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    obscurePasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider());
    ref.listen(authProvider(), (previous, next) {
      if (next is AuthError) {
        if (!mounted) return;
        final AuthError(:message) = next;
        CoreUtils.showSnackBar(
          context,
          message: message,
        );
      } else if (next is LoggedIn) {
        CoreUtils.postFrameCall(() => context.go('/', extra: 'home'));
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
          const Gap(20),
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
              }),
          const Gap(20),
          SizedBox(
            width: double.maxFinite,
            child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    context.push(ForgotPasswordScreen.path);
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyles.paragraphSubTextRegular1.primary,
                  ),
                )),
          ),
          const Gap(40),
          RoundedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                await ref.read(authProvider().notifier).login(
                      email: email,
                      password: password,
                    );
              }
            },
            text: 'Sign In',
          ).loading(authState is AuthLoading),
        ],
      ),
    );
  }
}
