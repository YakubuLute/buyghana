import 'package:buyghana/core/common/app/on_boarding_text.dart';
import 'package:buyghana/core/res/media.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    // get the full screen size for height and width
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Stack(
      children: [
        PageView(
          children: [
            OnBoardingWidget(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                image: Media.onBoardingFemale,
                title: OnBoardingText.title1,
                subTitle: OnBoardingText.subTitle1),
            OnBoardingWidget(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                image: Media.onBoardingFemale,
                title: OnBoardingText.title2,
                subTitle: OnBoardingText.subTitle2),
            OnBoardingWidget(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                image: Media.onBoardingFemale,
                title: OnBoardingText.title3,
                subTitle: OnBoardingText.subTitle3),
          ],
        ),
        Positioned(
          top: screenHeight * 0.9,
          left: screenWidth * 0.7,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {},
            label: const Text('Skip'),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: SmoothPageIndicator(
            controller: PageController(),
            count: 3,
            effect:
                ExpandingDotsEffect(activeDotColor: Colors.teal, dotHeight: 6),
          ),
        ),
        Positioned(
          top: screenHeight * 0.9,
          left: screenWidth * 0.7,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, shape: CircleBorder()),
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Continue'),
          ),
        ),
      ],
    ));
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
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Image.asset(
            image,
            width: screenWidth * 0.8,
            height: screenHeight * 0.6,
          ),
          SizedBox(
            height: screenHeight * 0.2,
          ),
          Text(title),
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Text(
            subTitle,
          ),
        ],
      ),
    );
  }
}
