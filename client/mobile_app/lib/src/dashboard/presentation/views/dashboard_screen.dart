import 'package:collection/collection.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecomly/core/extensions/context_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/cart/presentation/views/cart_view.dart';
import 'package:ecomly/src/dashboard/presentation/app/bottom_navigation_controller.dart';
import 'package:ecomly/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:ecomly/src/dashboard/presentation/widgets/dashboard_drawer.dart';
import 'package:ecomly/src/explore/presentation/views/explore_view.dart';
import 'package:ecomly/src/home/presentation/views/home_view.dart';
import 'package:ecomly/src/user/features/profile/presentation/views/profile_view.dart';
import 'package:ecomly/src/wishlist/presentation/views/wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({required this.state, required this.child, super.key});

  final Widget child;
  final GoRouterState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRouteIndex = DashboardUtils.activeIndex(state);
    final activeNavIndex = ref.watch(bottomNavigationControllerProvider);
    return Scaffold(
      key: DashboardUtils.scaffoldKey,
      body: child,
      drawer: const DashboardDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CurvedNavigationBar(
        index: activeNavIndex,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        color: CoreUtils.adaptiveColour(
          context,
          lightModeColour: Colours.lightThemeWhiteColour,
          darkModeColour: Colours.darkThemeDarkSharpColour,
        ),
        buttonBackgroundColor: Colours.lightThemePrimaryColour,
        items: DashboardUtils.iconList.mapIndexed((index, icon) {
          final isActive = activeRouteIndex == index;
          return Icon(
            isActive ? icon.$2 : icon.$1,
            size: 30,
            color: isActive
                ? Colours.lightThemeWhiteColour
                : Colours.lightThemeSecondaryTextColour,
          );
        }).toList(),
        onTap: (index) async {
          final router = GoRouter.of(context);
          final currentIndex = activeNavIndex;
          ref
              .read(bottomNavigationControllerProvider.notifier)
              .changeIndex(index);
          switch (index) {
            case 0:
              context.go(HomeView.path);
            case 1:
              context.go(ExploreView.path);
            case 2:
              await context.push(CartView.path);
              ref
                  .read(bottomNavigationControllerProvider.notifier)
                  .changeIndex(currentIndex);
            case 3:
              router.go(WishlistView.path);
            case 4:
              await router.push(ProfileView.path);
              ref
                  .read(bottomNavigationControllerProvider.notifier)
                  .changeIndex(currentIndex);
          }
        },
      ),
    );
  }
}
