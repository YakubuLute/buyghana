import 'package:flutter/material.dart';

abstract class CoreUtils {
  const CoreUtils();

  static Color adaptiveColor(BuildContext context,
      {required Color lightModeColor, required Color darkModeColor}) {
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark
        ? darkModeColor
        : lightModeColor;
  }
}
