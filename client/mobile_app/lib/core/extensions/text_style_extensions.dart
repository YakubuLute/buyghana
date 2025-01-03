import 'package:ecomly/core/res/styles/colours.dart';
import 'package:flutter/material.dart';

extension TextStyleExt on TextStyle {
  TextStyle get orange => copyWith(color: Colours.lightThemeSecondaryColour);

  TextStyle get dark => copyWith(color: Colours.lightThemePrimaryTextColour);

  TextStyle get grey => copyWith(color: Colours.lightThemeSecondaryTextColour);

  TextStyle get white => copyWith(color: Colours.lightThemeWhiteColour);

  TextStyle get primary => copyWith(color: Colours.lightThemePrimaryColour);

  TextStyle adaptiveColour(BuildContext context) =>
      copyWith(color: Colours.classicAdaptiveTextColour(context));
}
