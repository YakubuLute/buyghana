import 'package:ecomly/core/common/app/cache_helper.dart';
import 'package:ecomly/core/common/app/riverpod/current_user_provider.dart';
import 'package:ecomly/core/common/singletons/cache.dart';
import 'package:ecomly/core/common/widgets/ecomly.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/services/injection_container.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/auth/presentation/app/riverpod/auth_provider.dart';
import 'package:ecomly/src/user/presentation/app/auth_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final redirectNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider().notifier).verifyToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(currentUserProvider, (previous, next) {
      if (next != null) {
        CoreUtils.postFrameCall(() => context.go('/', extra: 'home'));
      }
    });
    ref.listen(authProvider(), (previous, next) async {
      if (next is TokenVerified) {
        if (next.isValid) {
          ref.read(authUserProvider().notifier).getUserById(
                Cache.instance.userId!,
              );
        } else {
          await sl<CacheHelper>().resetSession();
          CoreUtils.postFrameCall(() => context.go('/'));
        }
      } else if (next is AuthError) {
        if (next.message.startsWith('401')) {
          await sl<CacheHelper>().resetSession();
          redirectNotifier.value = true;
          CoreUtils.postFrameCall(() => context.go('/'));
          return;
        }
        CoreUtils.showSnackBar(context, message: next.message);
      }
    });

    ref.listen(authUserProvider(), (previous, next) {
      if (next is AuthUserError) {
        CoreUtils.showSnackBar(context, message: next.message);
      }
    });
    return Scaffold(
      backgroundColor: Colours.lightThemePrimaryColour,
      body: Center(
        child: ValueListenableBuilder(
            valueListenable: redirectNotifier,
            builder: (_, shouldRedirect, __) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Ecomly(),
                  if (shouldRedirect) ...[
                    const Gap(20),
                    ElevatedButton(
                      onPressed: () async {
                        final router = GoRouter.of(context);
                        await sl<CacheHelper>().resetSession();
                        router.go('/');
                      },
                      child: const Text('Click to ' 'continue'),
                    ),
                  ],
                ],
              );
            }),
      ),
    );
  }
}
