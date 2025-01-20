import 'package:flutter/widgets.dart';

abstract class TextStyles {
  /// weight: w700
  ///
  /// size: 48
  ///
  /// height: 2.4 >> 57.6px
  static const TextStyle headingBold = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700, // bold
    height: 1.2, // 57.6px
  );

  /// weight: w700
  ///
  /// size: 20
  ///
  /// height: 1.5 >> 30px
  static const TextStyle headingBold1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700, // bold
    height: 1.5, // 30px
  );

  /// weight: w400
  ///
  /// size: 20
  ///
  /// height: 1.5 >> 30px
  static const TextStyle headingRegular = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400, // regular
    height: 1.5, // 30px
  );

  /// weight: w700
  ///
  /// size: 30
  ///
  /// height: 1.5 >> 45px
  static const TextStyle headingBold3 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700, // bold
    height: 1.5, // 45px
  );

  /// weight: w600
  ///
  /// size: 22
  ///
  /// height: 1.5 >> 33px
  static const TextStyle headingSemiBold = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.5, // 33px
  );

  /// weight: w600
  ///
  /// size: 16
  ///
  /// height: 1.5 >> 24px
  static const TextStyle headingSemiBold1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.5, // 24px
  );

  /// weight: w500
  ///
  /// size: 28
  ///
  /// height: 1.5 >> 42px
  static const TextStyle headingMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500, // medium
    height: 1.5, // 42px
  );

  /// weight: w500
  ///
  /// size: 24
  ///
  /// height: 1.5 >> 36px
  static const TextStyle headingMedium1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500, // medium
    height: 1.5, // 36px
  );

  /// weight: w500
  ///
  /// size: 22
  ///
  /// height: 1.5 >> 33px
  static const TextStyle headingMedium2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500, // medium
    height: 1.5, // 33px
  );

  /// weight: w500
  ///
  /// size: 20
  ///
  /// height: 1.5 >> 30px
  static const TextStyle headingMedium3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500, // medium
    height: 1.5, // 30px
  );

  /// weight: w500
  ///
  /// size: 16
  ///
  /// height: 1.5 >> 24px
  static const TextStyle headingMedium4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500, // medium
    height: 1.5, // 24px
  );

  /// weight: w600
  ///
  /// size: 20
  ///
  /// height: 1.5 >> 30px
  static const TextStyle buttonTextHeadingSemiBold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600, // semi bold
    height: 1.5, // 30px
  );

  /// weight: w400
  ///
  /// size: 12
  ///
  /// height: 1.5 >> 18px
  static const TextStyle paragraphSubTextRegular = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400, // regular
    height: 1.5, // 18px
  );

  /// weight: w400
  ///
  /// size: 16
  ///
  /// height: 1.5 >> 24px
  static const TextStyle paragraphSubTextRegular1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400, // regular
    height: 1.5, // 24px
  );

  /// weight: w400
  ///
  /// size: 13
  ///
  /// height: 1.5 >> 19.5px
  static const TextStyle paragraphSubTextRegular2 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400, // regular
    height: 1.5, // 19.5px
  );

  /// weight: w400
  ///
  /// size: 14
  ///
  /// height: 1.5 >> 21px
  static const TextStyle paragraphSubTextRegular3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400, // regular
    height: 1.5, // 21px
  );

  /// weight: w400
  ///
  /// size: 14
  ///
  /// height: 1.71 >> 24px
  static const TextStyle paragraphRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400, // regular
    height: 1.71, // 24px
  );

  static const TextStyle appLogo = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
  );
}
