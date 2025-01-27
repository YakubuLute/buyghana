import 'package:flutter/material.dart';
import 'package:flutter_sliding_toast/flutter_sliding_toast.dart';

enum ToastType { success, error, warning, info }

class ToastUtils {
  static void showSlidingToast({
    required BuildContext context,
    required String message,
    ToastType toastType = ToastType.success,
    Duration animationDuration = const Duration(seconds: 1),
    Duration displayDuration = const Duration(seconds: 2),
    ToastPosition position = ToastPosition.top,
  }) {
    InteractiveToast.slide(
      context,
      leading: _leadingWidget(toastType),
      title: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      toastStyle: const ToastStyle(titleLeadingGap: 10),
      toastSetting: SlidingToastSetting(
        animationDuration: animationDuration,
        displayDuration: displayDuration,
        toastStartPosition: position,
        toastAlignment: position == ToastPosition.top
            ? Alignment.topCenter
            : Alignment.bottomCenter,
      ),
    );
  }

  static void showPopupToast({
    required BuildContext context,
    required String message,
    ToastType toastType = ToastType.success,
    Duration animationDuration = const Duration(seconds: 1),
    Duration displayDuration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
  }) {
    InteractiveToast.pop(
      context,
      leading: _leadingWidget(toastType),
      title: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.close, color: Colors.white),
      toastSetting: PopupToastSetting(
        animationDuration: animationDuration,
        displayDuration: displayDuration,
        toastAlignment: alignment,
      ),
    );
  }

  static Widget _leadingWidget(ToastType toastType) {
    Color backgroundColor;
    String emoji;

    switch (toastType) {
      case ToastType.error:
        backgroundColor = Colors.red;
        emoji = "❌";
        break;
      case ToastType.warning:
        backgroundColor = Colors.orange;
        emoji = "⚠️";
        break;
      case ToastType.info:
        backgroundColor = Colors.blue;
        emoji = "ℹ️";
        break;
      case ToastType.success:
      default:
        backgroundColor = Colors.green;
        emoji = "✅";
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            spreadRadius: 3,
            blurRadius: 4,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
