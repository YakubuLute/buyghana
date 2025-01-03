import 'dart:ui';

import 'package:ecomly/core/utils/enums/order_status_enum.dart';

abstract class OrderUtils {
  static Color? getSpecialTimelineColour(
    OrderStatus status, {
    Color? defaultColour,
  }) {
    return switch (status.category) {
      'completed' || 'cancelled' => status.colour,
      _ => defaultColour,
    };
  }
}
