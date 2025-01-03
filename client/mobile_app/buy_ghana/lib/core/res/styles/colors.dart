import 'package:bug_ghana/core/utils/core_utils.dart';
import 'package:flutter/material.dart';

abstract class CustomColors {
  static const Color lightThemePrimaryTint = Color(0xff9e9cdc);
  static const Color lightThemeSecondaryTint = Color(0xff673ab7);

  // Primary and Secondary colors
  static const Color lightThemePrimaryColor = Color(0xfff76631);
  static const Color lightThemeSecondaryColor = Color(0xfff76631);

  // Text colors
  static const Color lightThemePrimaryTextColor = Color(0xff282344);
  static const Color lightThemeSecondaryTextColor = Color(0xff9491a1);

  // Additional theme colors
  static const Color lightThemePinkColor = Color(0xfff08e98);
  static const Color lightThemeWhiteColor = Color(0xffffffff);
  static const Color lightThemeTintStockColor = Color(0xfff6f6f9);
  static const Color lightThemeYellowColor = Color(0xfffec613);
  static const Color lightThemeStockColor = Color(0xffe4e4e9);

  // dark colors
  static const Color darkThemeDarkSharpColor = Color(0xff191821);
  static const Color darkThemeDarkBGDark = Color(0xff0e0d11);
  static const Color darkThemeDarkNavBarColor = Color(0xff201f27);

  // adaptive color
  static Color classicAddaptiveTextColor(BuildContext context) =>
      CoreUtils.adaptiveColor(context,
          lightModeColor: lightThemeWhiteColor,
          darkModeColor: lightThemePrimaryTextColor);
}
