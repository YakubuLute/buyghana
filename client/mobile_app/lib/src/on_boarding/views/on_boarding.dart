import 'package:buyghana/core/res/media.dart';
import 'package:flutter/material.dart';

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
                screenWidth: screenWidth, screenHeight: screenHeight)
          ],
        )
      ],
    ));
  }
}

class OnBoardingWidget extends StatelessWidget {
  const OnBoardingWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
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
            Media.onBoardingFemale,
            width: screenWidth * 0.8,
            height: screenHeight * 0.6,
          ),
          SizedBox(
            height: screenHeight * 0.2,
          ),
          Text(
            "Discover Ghana's Finest Crafts",
          ),
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Text(
            "Supporting Local Artisans, Celebrating Ghanaian Heritage",
          ),
        ],
      ),
    );
  }
}
