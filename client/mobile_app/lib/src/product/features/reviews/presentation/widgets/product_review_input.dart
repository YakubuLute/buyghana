import 'package:ecomly/core/common/app/riverpod/current_user_provider.dart';
import 'package:ecomly/core/common/widgets/input_field.dart';

// import 'package:ecomly/core/common/widgets/rating_stars.dart';
import 'package:ecomly/core/extensions/double_extensions.dart';
import 'package:ecomly/core/extensions/string_extensions.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/extensions/widget_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/presentation/app/product_riverpod_provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ProductReviewInput extends StatefulWidget {
  const ProductReviewInput(
    this.product, {
    required this.reviewsFamilyKey,
    super.key,
  });

  final Product product;
  final GlobalKey reviewsFamilyKey;

  @override
  State<ProductReviewInput> createState() => _ProductReviewInputState();
}

class _ProductReviewInputState extends State<ProductReviewInput> {
  final ratingNotifier = ValueNotifier<double>(0);
  final controller = TextEditingController();
  final productAdapterFamilyKey = GlobalKey();

  @override
  void dispose() {
    controller.dispose();
    ratingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      final user = ref.watch(currentUserProvider);
      final productAdapter = ref.watch(
        productAdapterProvider(productAdapterFamilyKey),
      );

      ref.listen(
        productAdapterProvider(productAdapterFamilyKey),
        (previous, next) {
          if (next is ProductError) {
            CoreUtils.showSnackBar(context, message: next.message);
          } else if (next is ProductReviewed) {
            CoreUtils.postFrameCall(() {
              ratingNotifier.value = 0;
              controller.clear();
              ref
                  .read(
                      productAdapterProvider(widget.reviewsFamilyKey).notifier)
                  .getProductReviews(
                    productId: widget.product.id,
                    page: 1,
                  );
            });
          }
        },
      );
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colours.lightThemePrimaryColour,
                child: Center(
                  child: Text(
                    user!.name.initials,
                    style: TextStyles.headingMedium4.white,
                  ),
                ),
              ),
              const Gap(20),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style:
                          TextStyles.headingSemiBold1.adaptiveColour(context),
                    ),
                    const Gap(5),
                    Text(
                      'Reviews are public and include your account info.',
                      style: TextStyles.paragraphSubTextRegular3
                          .adaptiveColour(context)
                          .copyWith(fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(15),
          ValueListenableBuilder(
              valueListenable: ratingNotifier,
              builder: (_, value, __) {
                return Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: RatingStars(
                    value: value,
                    onValueChanged: (newValue) {
                      ratingNotifier.value = newValue;
                    },
                    starBuilder: (index, color) {
                      if (value.canFill(index + 1)) {
                        return Icon(
                          Icons.star,
                          color: color,
                        );
                      }
                      return Icon(
                        Icons.star_outline,
                        color: color,
                      );
                    },
                    starCount: 5,
                    starSize: 30,
                    valueLabelColor: const Color(0xff9b9b9b),
                    valueLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0,
                    ),
                    valueLabelRadius: 10,
                    maxValue: 5,
                    starSpacing: 4,
                    maxValueVisibility: true,
                    valueLabelVisibility: true,
                    animationDuration: const Duration(seconds: 1),
                    valueLabelPadding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                    valueLabelMargin: const EdgeInsets.only(right: 8),
                    starOffColor: Colors.grey,
                    starColor: Colors.amber,
                  ),
                  /* child: RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    unratedColor: CoreUtils.adaptiveColour(
                      context,
                      lightModeColour: const Color(0xFFffeeb9),
                      darkModeColour: const Color(0xFF564411),
                    ),
                    updateOnDrag: true,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, index) {
                      if (value.canFill(index + 1)) {
                        return const Icon(
                          Icons.star,
                          color: Colors.amber,
                        );
                      }
                      return const Icon(
                        Icons.star_outline,
                      );
                    },
                    onRatingUpdate: (rating) {
                      ratingNotifier.value = rating;
                    },
                  ),*/
                );
              }),
          const Gap(25),
          InputField(
            controller: controller,
            expandable: true,
            hintText: 'Describe your experience',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          const Gap(16),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colours.lightThemePrimaryColour,
              foregroundColor: Colours.lightThemeWhiteColour,
            ),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (controller.text.trim().isNotEmpty ||
                  ratingNotifier.value >= 1) {
                ref
                    .read(
                      productAdapterProvider(productAdapterFamilyKey).notifier,
                    )
                    .leaveReview(
                      productId: widget.product.id,
                      userId: user.id,
                      comment: controller.text.trim(),
                      rating:
                          ratingNotifier.value < 1 ? 1 : ratingNotifier.value,
                    );
              }
            },
            child: const Text('POST'),
          ).loading(productAdapter is Reviewing),
        ],
      );
    });
  }
}
