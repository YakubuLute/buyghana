import 'package:ecomly/core/common/app/cache_helper.dart';
import 'package:ecomly/core/common/app/riverpod/current_user_provider.dart';
import 'package:ecomly/core/common/singletons/cache.dart';
import 'package:ecomly/core/common/widgets/bottom_sheet_card.dart';
import 'package:ecomly/core/common/widgets/rounded_button.dart';
import 'package:ecomly/core/extensions/string_extensions.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/extensions/widget_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/services/injection_container.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/dashboard/presentation/app/bottom_navigation_controller.dart';
import 'package:ecomly/src/dashboard/presentation/widgets/theme_toggle.dart';
import 'package:ecomly/src/user/features/profile/presentation/views/profile_view.dart';
import 'package:ecomly/src/user/presentation/app/auth_user_provider.dart';
import 'package:ecomly/src/user/presentation/views/payment_profile_view.dart';
import 'package:ecomly/src/wishlist/presentation/views/wishlist_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardDrawer extends ConsumerStatefulWidget {
  const DashboardDrawer({super.key});

  static final drawerItems = [
    ('Profile', IconlyBroken.profile),
    ('Payment Profile', IconlyBroken.scan),
    ('Wishlist', IconlyBroken.heart),
    ('My Orders', IconlyBroken.time_circle),
    ('Privacy Policy', IconlyBroken.shield_done),
    ('Terms & Conditions', IconlyBroken.document),
  ];

  @override
  ConsumerState<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends ConsumerState<DashboardDrawer> {
  final signingOutNotifier = ValueNotifier(false);
  final authUserFamilyKey = GlobalKey();

  @override
  void dispose() {
    signingOutNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final authUserAdapter = ref.watch(authUserProvider(authUserFamilyKey));

    ref.listen(
      authUserProvider(authUserFamilyKey),
      (previous, next) {
        if (next is AuthUserError) {
          CoreUtils.postFrameCall(() {
            Scaffold.of(context).closeDrawer();
          });
          CoreUtils.showSnackBar(context, message: next.message);
        } else if (next is FetchedUserPaymentProfile) {
          final url = next.paymentProfileUrl;
          CoreUtils.postFrameCall(() async {
            final scaffold = Scaffold.of(context);
            if (defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS) {
              context.push(PaymentProfileView.path, extra: url);
            } else {
              if (!await launchUrl(Uri.parse(url))) {
                debugPrint('ERROR: Could not launch Payment profile url');
                if (!mounted) return;
                CoreUtils.showSnackBar(
                  context,
                  message: 'Error Occurred, '
                      'Please try again.\nIf issue persists, contact support.',
                );
              }
            }
            scaffold.closeDrawer();
          });
        }
      },
    );

    return Drawer(
      backgroundColor: CoreUtils.adaptiveColour(
        context,
        lightModeColour: Colours.lightThemeWhiteColour,
        darkModeColour: Colours.darkThemeDarkSharpColour,
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colours.lightThemePrimaryColour,
                    child: Center(
                      child: Text(
                        user!.name.initials,
                        style: TextStyles.headingMedium.white,
                      ),
                    ),
                  ),
                  const Gap(15),
                  Text(
                    user.name,
                    style: TextStyles.headingMedium.adaptiveColour(context),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.separated(
              itemCount: 6,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, index) => Divider(
                color: CoreUtils.adaptiveColour(
                  context,
                  darkModeColour: Colours.darkThemeDarkNavBarColour,
                  lightModeColour: Colours.lightThemeWhiteColour,
                ),
              ),
              itemBuilder: (context, index) {
                final drawerItem = DashboardDrawer.drawerItems[index];
                return ListTile(
                  leading: Icon(
                    drawerItem.$2,
                    color: Colours.classicAdaptiveTextColour(context),
                  ),
                  title: Text(
                    drawerItem.$1,
                    style: TextStyles.headingMedium3.adaptiveColour(context),
                  ).loading(
                    index == 1 && authUserAdapter is GettingUserPaymentProfile,
                  ),
                  onTap: () {
                    if (index != 1) Scaffold.of(context).closeDrawer();
                    switch (index) {
                      case 0:
                        context.push(ProfileView.path);
                      case 1:
                        ref
                            .read(authUserProvider(authUserFamilyKey).notifier)
                            .getUserPaymentProfile(Cache.instance.userId!);
                      case 2:
                        ref
                            .read(bottomNavigationControllerProvider.notifier)
                            .changeIndex(3);
                        context.go(WishlistView.path);
                      case 3:
                        context.push('/users/${Cache.instance.userId}/orders');
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
              bottom: 20,
              top: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ThemeToggle(),
                const Gap(5),
                ValueListenableBuilder(
                  valueListenable: signingOutNotifier,
                  builder: (_, value, __) {
                    return RoundedButton(
                      height: 50,
                      onPressed: () async {
                        final router = GoRouter.of(context);
                        final result = await showModalBottomSheet<bool>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          isDismissible: false,
                          builder: (_) {
                            return const BottomSheetCard(
                              title: 'Are you sure you want to Sign Out?',
                              positiveButtonText: 'Yes',
                              negativeButtonText: 'Cancel',
                              positiveButtonColour:
                                  Colours.lightThemeSecondaryColour,
                            );
                          },
                        );
                        if (result ?? false) {
                          signingOutNotifier.value = true;
                          await sl<CacheHelper>().resetSession();
                          router.go('/');
                        }
                      },
                      text: 'Sign Out',
                    ).loading(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
