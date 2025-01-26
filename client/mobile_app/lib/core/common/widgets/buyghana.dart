import 'package:buyghana/core/extensions/text_style_extensions.dart';
import 'package:buyghana/core/res/styles/colours.dart';
import 'package:buyghana/core/res/styles/text.dart';
import 'package:flutter/material.dart';

class BuyGhana extends StatelessWidget {
  const BuyGhana({super.key, this.style});

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Buy',
        style: style ?? TextStyles.appLogo.white,
        children: const [
          TextSpan(
            text: 'Ghana',
            style: TextStyle(color: Colours.lightThemeSecondaryColour),
          ),
        ],
      ),
    );
  }
}
