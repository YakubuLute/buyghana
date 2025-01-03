import 'package:ecomly/core/utils/enums/order_status_enum.dart';
import 'package:flutter/material.dart';

extension StringExt on String {
  Map<String, String> get toHeaders {
    return {
      'Authorization': 'Bearer $this',
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  String get obscureEmail {
    // Split the email into username and domain
    final index = indexOf('@');
    var username = substring(0, index);
    final domain = substring(index + 1);
    // Obscure the username and display only the first and last characters
    username = '${username[0]}****${username[username.length - 1]}';
    // Return the obscured email
    return '$username@$domain';
  }

  Color get colour {
    return Color(int.parse(replaceFirst('#', 'ff'), radix: 16));
  }

  String truncateWithEllipsis(int maxLength) {
    if (length <= maxLength) {
      return this;
    } else {
      return '${substring(0, maxLength)}...';
    }
  }

  String get initials {
    if (isEmpty) return '';
    List<String> words = trim().split(' ');

    String initials = '';

    for (int i = 0; i < words.length && i < 2; i++) {
      initials += words[i][0];
    }

    return initials.toUpperCase();
  }

  String get capitalize {
    if (trim().isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String get titleCase {
    if (trim().isEmpty) return this;
    return split(' ').map<String>((e) => e.capitalize).toList().join(' ');
  }

  OrderStatus get toStatus {
    return switch (toLowerCase()) {
      'pending' => OrderStatus.pending,
      'processed' => OrderStatus.processed,
      'shipped' => OrderStatus.shipped,
      'out-for-delivery' => OrderStatus.outForDelivery,
      'delivered' => OrderStatus.delivered,
      'cancelled' => OrderStatus.cancelled,
      'on-hold' => OrderStatus.onHold,
      'expired' => OrderStatus.expired,
      _ => OrderStatus.pending,
    };
  }

  ThemeMode get toThemeMode {
    return switch (toLowerCase()) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
