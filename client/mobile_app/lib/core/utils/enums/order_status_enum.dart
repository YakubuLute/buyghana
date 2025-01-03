import 'package:flutter/material.dart';

enum OrderStatus {
  pending(
    colour: Colors.orange,
    category: 'active',
    displayName: 'Pending',
    value: 'pending',
  ),
  processed(
    colour: Colors.orange,
    category: 'active',
    displayName: 'Processed',
    value: 'processed',
  ),
  shipped(
    colour: Colors.orange,
    category: 'active',
    displayName: 'Shipped',
    value: 'shipped',
  ),
  outForDelivery(
    colour: Colors.orange,
    category: 'active',
    displayName: 'Out For Delivery',
    value: 'out-for-delivery',
  ),
  delivered(
    colour: Colors.green,
    category: 'completed',
    displayName: 'Delivered',
    value: 'delivered',
  ),
  cancelled(
    colour: Colors.red,
    category: 'cancelled',
    displayName: 'Cancelled',
    value: 'cancelled',
  ),
  onHold(
    colour: Colors.yellow,
    category: 'active',
    displayName: 'On Hold',
    value: 'on-hold',
  ),
  expired(
    colour: Colors.red,
    category: 'cancelled',
    displayName: 'Expired',
    value: 'expired',
  );

  const OrderStatus({
    required this.colour,
    required this.category,
    required this.displayName,
    required this.value,
  });

  final Color colour;
  final String category;
  final String displayName;
  final String value;
}
