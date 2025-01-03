import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:flutter/material.dart';

class CartProductQuantityStepperIcon extends StatelessWidget {
  const CartProductQuantityStepperIcon.decrement({super.key, this.onTap})
      : increase = false;

  const CartProductQuantityStepperIcon.increment({super.key, this.onTap})
      : increase = true;

  final bool increase;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: CoreUtils.adaptiveColour(
            context,
            lightModeColour: Colours.lightThemeWhiteColour,
            darkModeColour: Colours.darkThemeDarkNavBarColour,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            increase ? Icons.add : Icons.remove,
            size: 14,
            color: Colours.classicAdaptiveTextColour(context),
          ),
        ),
      ),
    );
  }
}
