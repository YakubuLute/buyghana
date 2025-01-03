import 'package:ecomly/core/utils/core_utils.dart';
import 'package:flutter/material.dart';

abstract class Colours {
  // lightThemePrimaryTint Color Swatch
  static const Color lightThemePrimaryTint = Color(0xff9e9cdc);

  // lightThemePrimaryColor Color Swatch
  static const Color lightThemePrimaryColour = Color(0xff524eb7);

  // lightThemeSecondaryColor Color Swatch
  static const Color lightThemeSecondaryColour = Color(0xfff76631);

  // lightThemePrimaryTextColor Color Swatch
  static const Color lightThemePrimaryTextColour = Color(0xff282344);

  // lightThemeSecondaryTextColor Color Swatch
  static const Color lightThemeSecondaryTextColour = Color(0xff9491a1);

  // lightThemePinkColor Color Swatch
  static const Color lightThemePinkColour = Color(0xfff08e98);

  // lightThemeWhiteColor Color Swatch
  static const Color lightThemeWhiteColour = Color(0xffffffff);

  // lightThemeTintStockColor Color Swatch
  static const Color lightThemeTintStockColour = Color(0xfff6f6f9);

  // lightThemeYellowColor Color Swatch
  static const Color lightThemeYellowColour = Color(0xfffec613);

  // lightThemeStockColor Color Swatch
  static const Color lightThemeStockColour = Color(0xffe4e4e9);

  // darkThemeDarkSharpColor Color Swatch
  static const Color darkThemeDarkSharpColour = Color(0xff191821);

  // darkThemeBGDark Color Swatch
  static const Color darkThemeBGDark = Color(0xff0e0d11);

  // darkThemeDarkNavBarColor Color Swatch
  static const Color darkThemeDarkNavBarColour = Color(0xff201f27);

  static Color classicAdaptiveTextColour(BuildContext context) =>
      CoreUtils.adaptiveColour(
        context,
        darkModeColour: Colours.lightThemeWhiteColour,
        lightModeColour: Colours.lightThemePrimaryTextColour,
      );
}
