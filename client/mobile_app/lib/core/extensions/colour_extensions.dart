import 'dart:ui';

extension ColourExt on Color {
  String get hex {
    return toString().substring(8, 16).toLowerCase().replaceFirst('ff', '#');
  }

  Color get inverse {
    return Color.fromARGB(
      alpha,
      255 - red,
      255 - green,
      255 - blue,
    );
  }
}
