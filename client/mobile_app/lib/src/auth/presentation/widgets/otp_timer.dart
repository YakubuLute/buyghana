import 'dart:async';

import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/src/auth/presentation/app/riverpod/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPTimer extends ConsumerStatefulWidget {
  const OTPTimer({required this.email, required this.familyKey, super.key});

  final String email;
  final GlobalKey familyKey;

  @override
  ConsumerState<OTPTimer> createState() => _OTPTimerState();
}

class _OTPTimerState extends ConsumerState<OTPTimer> {
  int _mainDuration = 60;

  // Timer duration in seconds
  int _duration = 60;

  int increment = 10;

  // Timer
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the timer
    _startTimer();
  }

  bool canResend = false;
  bool resending = false;

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    // Set the timer to expire after the duration
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration--;
      });
      if (_duration == 0) {
        // Increase the duration by 10 seconds after each request
        if (_mainDuration > 60) {
          increment *= 2;
        }
        _mainDuration += increment;
        _duration = _mainDuration;
        // Cancel the timer
        timer.cancel();

        setState(() {
          canResend = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the number of minutes and seconds
    final minutes = _duration ~/ 60;
    final seconds = _duration.remainder(60);
    return Center(
      child: canResend
          ? (resending
              ? const Center(
                  child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colours.lightThemePrimaryColour,
                ))
              : TextButton(
                  onPressed: () async {
                    setState(() {
                      resending = true;
                    });
                    await ref
                        .read(authProvider(widget.familyKey).notifier)
                        .forgotPassword(
                          email: widget.email,
                        );
                    setState(() {
                      resending = false;
                    });
                    _startTimer();
                    setState(() {
                      canResend = false;
                    });
                  },
                  child: Text(
                    'Resend Code',
                    style: TextStyles.headingMedium4.primary,
                  ),
                ))
          : RichText(
              text: TextSpan(
                text: 'Resend code in ',
                style: TextStyles.headingMedium4.grey,
                children: [
                  TextSpan(
                    text: '$minutes:${seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Colours.lightThemePrimaryColour,
                    ),
                  ),
                  const TextSpan(text: ' seconds'),
                ],
              ),
            ),
    );
  }
}
