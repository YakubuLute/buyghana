import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/heroicons_outline.dart';

class MenuIcon extends StatelessWidget {
  const MenuIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final adaptiveColour = Colours.classicAdaptiveTextColour(context);
    return Center(
      child: GestureDetector(
        onTap: () {
          DashboardUtils.scaffoldKey.currentState?.openDrawer();
        },
        child: Iconify(
          HeroiconsOutline.menu_alt_2,
          size: 24,
          color: adaptiveColour,
        ),
      ),
    );
  }
}
