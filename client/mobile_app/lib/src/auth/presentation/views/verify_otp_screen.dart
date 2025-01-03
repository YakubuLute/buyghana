import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/common/widgets/rounded_button.dart';
import 'package:ecomly/core/extensions/string_extensions.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/extensions/widget_extensions.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/auth/presentation/app/riverpod/auth_provider.dart';
import 'package:ecomly/src/auth/presentation/views/reset_password_screen.dart';
import 'package:ecomly/src/auth/presentation/widgets/otp_fields.dart';
import 'package:ecomly/src/auth/presentation/widgets/otp_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class VerifyOTPScreen extends ConsumerStatefulWidget {
  const VerifyOTPScreen({required this.email, super.key});

  static const path = '/verify-otp';

  final String email;

  @override
  ConsumerState<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends ConsumerState<VerifyOTPScreen> {
  final otpController = TextEditingController();
  final familyKey = GlobalKey();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider(familyKey));
    ref.listen(authProvider(familyKey), (previous, next) {
      if (next is AuthError) {
        CoreUtils.showSnackBar(context, message: next.message);
      } else if (next is OTPVerified) {
        CoreUtils.postFrameCall(
          () => context.pushReplacement(
            ResetPasswordScreen.path,
            extra: widget.email,
          ),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify OTP',
          style: TextStyles.headingSemiBold,
        ),
        bottom: const AppBarBottom(),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        children: [
          Text(
            'Verification Code',
            style: TextStyles.headingBold3.adaptiveColour(context),
          ),
          Text(
            'Code has been sent to ${widget.email.obscureEmail}',
            style: TextStyles.paragraphSubTextRegular1.grey,
          ),
          const Gap(20),
          OTPFields(controller: otpController),
          const Gap(30),
          OTPTimer(email: widget.email, familyKey: familyKey),
          const Gap(40),
          RoundedButton(
            onPressed: () async {
              if (otpController.text.length < 4) {
                CoreUtils.showSnackBar(context, message: 'Invalid OTP');
              } else {
                final router = GoRouter.of(context);
                await ref.read(authProvider(familyKey).notifier).verifyOTP(
                      email: widget.email,
                      otp: otpController.text.trim(),
                    );
                router.pushReplacement(
                  ResetPasswordScreen.path,
                  extra: widget.email,
                );
              }
            },
            text: 'Verify',
          ).loading(auth is AuthLoading),
        ],
      ),
    );
  }
}
