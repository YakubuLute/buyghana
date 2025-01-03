import 'package:ecomly/core/common/widgets/dynamic_loader_widget.dart';
import 'package:flutter/widgets.dart';

extension WidgetExt on Widget {
  DynamicLoaderWidget loading(bool isLoading) {
    return DynamicLoaderWidget(originalWidget: this, isLoading: isLoading);
  }
}
