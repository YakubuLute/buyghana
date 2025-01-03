import 'package:ecomly/core/common/widgets/rounded_button.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:flutter/material.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colours.lightThemePrimaryColour,
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Up to', style: TextStyles.paragraphSubTextRegular1.white),
                Text('50% off', style: TextStyles.headingBold3.white),
                Text(
                  'WITH CODE',
                  style: TextStyle(
                    fontSize: 25,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = .6
                      ..color = Colours.lightThemeWhiteColour,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: RoundedButton(
                text: 'Get it now',
                textStyle: TextStyles.headingBold3.primary.copyWith(
                  fontSize: 14,
                ),
                backgroundColour: Colours.lightThemeWhiteColour,
                height: 54,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
