import 'package:buyghana/core/common/widgets/app_bar_bottom.dart';
import 'package:buyghana/core/common/widgets/buyghana.dart';
import 'package:buyghana/core/res/styles/colours.dart';
import 'package:buyghana/core/res/styles/text.dart';
import 'package:buyghana/core/utils/core_utils.dart';
import 'package:buyghana/src/dashboard/presentation/widgets/menu_icon.dart';
import 'package:buyghana/src/home/presentation/widgets/reactive_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final adaptiveColour = Colours.classicAdaptiveTextColour(context);
    return AppBar(
      leading: const MenuIcon(),
      centerTitle: false,
      titleSpacing: 0,
      title: BuyGhana(
        style: TextStyles.headingSemiBold.copyWith(
          color: CoreUtils.adaptiveColour(
            context,
            darkModeColour: Colours.lightThemePrimaryTint,
            lightModeColour: Colours.lightThemePrimaryColour,
          ),
        ),
      ),
      bottom: const AppBarBottom(),
      actions: [
        const ReactiveCartIcon(),
        const Gap(20),
        Icon(IconlyBold.scan, color: adaptiveColour),
        const Gap(20),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
