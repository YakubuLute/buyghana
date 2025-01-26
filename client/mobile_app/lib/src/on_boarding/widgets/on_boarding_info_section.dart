import 'package:buyghana/core/common/app/cache_helper.dart';
import 'package:buyghana/core/common/widgets/rounded_button.dart';
import 'package:buyghana/core/res/media.dart';
import 'package:buyghana/core/res/styles/colours.dart';
import 'package:buyghana/core/res/styles/text.dart';
import 'package:buyghana/core/services/injection_container.dart';
import 'package:buyghana/core/utils/core_utils.dart';
import 'package:buyghana/src/auth/presentation/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnBoardingInfoSection extends StatelessWidget {
  const OnBoardingInfoSection.first({super.key}) : first = true;

  const OnBoardingInfoSection.second({super.key}) : first = false;

  final bool first;

  @override
  Widget build(BuildContext context) {
    final adaptiveColour = CoreUtils.adaptiveColour(
      context,
      darkModeColour: Colors.white,
      lightModeColour: Colours.lightThemePrimaryTextColour,
    );
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset(first ? Media.onBoardingFemale : Media.onBoardingMale),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (first)
                  Text.rich(
                    textAlign: TextAlign.left,
                    TextSpan(
                        text: 'Buy Ghana\n',
                        style: TextStyles.headingBold.copyWith(
                          color: Colours.lightThemeSecondaryColour,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Enjoy the best sales of made in Ghana products',
                            style: TextStyle(
                              color: adaptiveColour,
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ]),
                  )
                else
                  Text.rich(
                    textAlign: TextAlign.left,
                    TextSpan(
                      text: 'Flash Sale\n',
                      style: TextStyles.headingBold.copyWith(
                        color: adaptiveColour,
                      ),
                      children: [
                        const TextSpan(
                          text: "Men's ",
                          style: TextStyle(
                            color: Colours.lightThemeSecondaryColour,
                          ),
                        ),
                        TextSpan(
                          text: 'Shirts & Watches',
                          style: TextStyle(
                            color: CoreUtils.adaptiveColour(
                              context,
                              darkModeColour: Colors.white,
                              lightModeColour:
                                  Colours.lightThemePrimaryTextColour,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                RoundedButton(
                  text: 'Get Started',
                  onPressed: () {
                    sl<CacheHelper>().cacheFirstTimer();
                    context.go(LoginScreen.path);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
