import 'package:ecomly/core/common/widgets/bottom_sheet_card.dart';
import 'package:flutter/material.dart';

abstract class CartUtils {
  static Future<bool> verifyDeletion(BuildContext context,
      {String? message}) async {
    final finalMessage =
        message ?? 'Are you sure you want to remove this item?';
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isDismissible: false,
      builder: (_) {
        return BottomSheetCard(
          title: finalMessage,
          positiveButtonText: 'Remove',
          negativeButtonText: 'Cancel',
          positiveButtonColour: Colors.red,
        );
      },
    );

    return result ?? false;
  }
}
