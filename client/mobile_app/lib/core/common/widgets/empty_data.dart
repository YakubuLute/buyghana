import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  const EmptyData(this.data, {super.key, this.padding});

  final String data;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          data,
          textAlign: TextAlign.center,
          style: TextStyles.headingBold.copyWith(
            color: Colours.lightThemeSecondaryTextColour.withOpacity(.6),
          ),
        ),
      ),
    );
  }
}
