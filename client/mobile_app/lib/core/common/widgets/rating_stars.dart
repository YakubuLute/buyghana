import 'package:ecomly/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingStars extends StatelessWidget {
  const RatingStars(this.rating, {super.key});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) => const Icon(
        Icons.star_rounded,
        color: Colors.amber,
      ),
      unratedColor: CoreUtils.adaptiveColour(
        context,
        lightModeColour: const Color(0xFFffeeb9),
        darkModeColour: const Color(0xFF564411),
      ),
      itemSize: 17,
    );
  }
}
