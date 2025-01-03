import 'package:collection/collection.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/features/reviews/presentation/widgets/product_review_input.dart';
import 'package:ecomly/src/product/features/reviews/presentation/widgets/review_tile.dart';
import 'package:ecomly/src/product/presentation/app/product_riverpod_provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ReviewsPreview extends ConsumerStatefulWidget {
  const ReviewsPreview({required this.product, super.key});

  final Product product;

  @override
  ConsumerState createState() => _ReviewsPreviewState();
}

class _ReviewsPreviewState extends ConsumerState<ReviewsPreview> {
  final productAdapterFamilyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ref
            .read(productAdapterProvider(productAdapterFamilyKey).notifier)
            .getProductReviews(
              productId: widget.product.id,
              page: 1,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productAdapter = ref.watch(
      productAdapterProvider(productAdapterFamilyKey),
    );
    ref.listen(
      productAdapterProvider(productAdapterFamilyKey),
      (previous, next) {
        if (next is ProductError) {
          CoreUtils.showSnackBar(context, message: next.message);
        }
      },
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProductReviewInput(
          widget.product,
          reviewsFamilyKey: productAdapterFamilyKey,
        ),
        const Gap(50),
        Builder(
          builder: (_) {
            if (productAdapter is FetchingReviews) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colours.lightThemePrimaryColour,
                ),
              );
            } else if (productAdapter is ReviewsFetched &&
                productAdapter.reviews.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customer Reviews',
                        style:
                            TextStyles.headingMedium3.adaptiveColour(context),
                      ),
                      if (productAdapter.reviews.length > 4)
                        InkWell(
                          onTap: () {
                            context.push(
                              '/products/${widget.product.id}/reviews',
                              extra: widget.product,
                            );
                          },
                          child: Text(
                            'View All',
                            style: TextStyles.paragraphSubTextRegular1.orange,
                          ),
                        ),
                    ],
                  ),
                  const Gap(20),
                  ...productAdapter.reviews.take(4).mapIndexed((index, review) {
                    final lastReviewIndex =
                        productAdapter.reviews.take(4).length - 1;
                    return ReviewTile.preview(
                      review,
                      margin: index == lastReviewIndex
                          ? null
                          : const EdgeInsets.only(bottom: 35),
                    );
                  }),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
