import 'package:buyghana/core/common/app/cache_helper.dart';
import 'package:buyghana/core/common/app/on_boarding_text.dart';
import 'package:buyghana/core/res/media.dart';
import 'package:buyghana/core/res/styles/colours.dart';
import 'package:buyghana/core/services/injection_container.dart';
import 'package:buyghana/core/utils/core_utils.dart';
import 'package:buyghana/src/auth/presentation/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  // Track the current page index
  int activePageIndicator = 0;

  @override
  Widget build(BuildContext context) {
    // Get the full screen size for height and width
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final pageController = PageController();
    final adaptiveColour = CoreUtils.adaptiveColour(
      context,
      darkModeColour: Colors.white,
      lightModeColour: Colours.lightThemePrimaryTextColour,
    );

    // Update the active page indicator when the page changes
    void updatePageIndicator(int index) {
      setState(() {
        activePageIndicator = index;
      });
      print("Print active index $activePageIndicator");
    }

    return Scaffold(
      body: Stack(
        children: [
          // PageView to swipe through onboarding pages
          PageView(
            controller: pageController,
            onPageChanged: updatePageIndicator,
            children: [
              OnBoardingWidget(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                image: Media.onBoardingFemale,
                title: OnBoardingText.title1,
                subTitle: OnBoardingText.subTitle1,
              ),
              OnBoardingWidget(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                image: Media.onBoardingMale,
                title: OnBoardingText.title2,
                subTitle: OnBoardingText.subTitle2,
              ),
              OnBoardingWidget(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                image: Media.onBoardingFemale,
                title: OnBoardingText.title3,
                subTitle: OnBoardingText.subTitle3,
              ),
            ],
          ),

          // Skip Button
          Positioned(
            top: screenHeight / 15,
            right: screenWidth / 9,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                sl<CacheHelper>().cacheFirstTimer();
                context.go(LoginScreen.path);
              },
              label: const Text('Skip'),
            ),
          ),

          // Page Indicator
          Positioned(
            bottom: 20,
            left: 20,
            child: SmoothPageIndicator(
              controller: pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: adaptiveColour,
                dotHeight: 6,
              ),
            ),
          ),

          // Next/Continue Button
          Positioned(
            top: screenHeight * 0.93,
            right: screenWidth / 11,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: adaptiveColour,
                shape: activePageIndicator != 2 ? CircleBorder() : null,
              ),
              onPressed: () {
                if (activePageIndicator < 2) {
                  pageController.nextPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                } else {
                  // Navigate or handle "Continue" logic
                  print("Continue pressed!");
                  context.go(LoginScreen.path); // Navigate to login screen
                }
              },
              child: activePageIndicator == 2
                  ? const Text(
                      'Continue') // Ensure this is dynamically rendered
                  : const Icon(Icons
                      .arrow_forward), // Ensure this is dynamically rendered
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoardingWidget extends StatelessWidget {
  const OnBoardingWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final double screenWidth;
  final double screenHeight;
  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Image.asset(
            image,
            width: screenWidth * 0.8,
            height: screenHeight * 0.6,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CoreUtils.adaptiveColour(
                context,
                darkModeColour: Colors.white,
                lightModeColour: Colours.lightThemePrimaryTextColour,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: CoreUtils.adaptiveColour(
                context,
                darkModeColour: Colors.grey,
                lightModeColour: Colours.lightThemePrimaryTextColour,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
