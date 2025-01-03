import 'package:ecomly/src/cart/presentation/views/cart_view.dart';
import 'package:ecomly/src/explore/presentation/views/explore_view.dart';
import 'package:ecomly/src/home/presentation/views/home_view.dart';
import 'package:ecomly/src/user/features/profile/presentation/views/profile_view.dart';
import 'package:ecomly/src/wishlist/presentation/views/wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

abstract class DashboardUtils {
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  static final iconList = [
    (IconlyBroken.home, IconlyBold.home),
    (IconlyBroken.discovery, IconlyBold.discovery),
    (IconlyBroken.buy, IconlyBold.buy),
    (IconlyBroken.heart, IconlyBold.heart),
    (IconlyBroken.profile, IconlyBold.profile),
  ];

  static int activeIndex(GoRouterState state) {
    return switch (state.fullPath) {
      HomeView.path => 0,
      ExploreView.path => 1,
      CartView.path => 2,
      WishlistView.path => 3,
      ProfileView.path => 4,
      _ => 0,
    };
  }
}
