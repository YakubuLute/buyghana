import 'package:flutter/material.dart';

abstract class TextStyles {
  // Headers - Decreasing in size from h1 to h5
  static const TextStyle header1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle header2 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
    height: 1.3,
  );

  static const TextStyle header3 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle header4 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle header5 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  // Body texts - Different sizes for various purposes
  static const TextStyle body1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0.25,
  );

  static const TextStyle body3 = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0.25,
  );

  static const TextStyle body4 = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: 0.4,
  );

  static const TextStyle body5 = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: 0.4,
  );
}