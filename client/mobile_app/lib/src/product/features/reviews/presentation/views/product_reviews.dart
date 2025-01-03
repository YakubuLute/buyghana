import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/common/widgets/empty_data.dart';
import 'package:ecomly/core/common/widgets/rating_stars.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/constants/network_constants.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/domain/entities/review.dart';
import 'package:ecomly/src/product/features/reviews/presentation/widgets/review_tile.dart';
import 'package:ecomly/src/product/presentation/app/product_riverpod_provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ProductReviews extends ConsumerStatefulWidget {
  const ProductReviews(this.product, {super.key});

  final Product product;

  @override
  ConsumerState<ProductReviews> createState() => _ProductReviewsState();
}

class _ProductReviewsState extends ConsumerState<ProductReviews> {
  final pageController = PagingController<int, Review>(firstPageKey: 1);
  final productAdapterFamilyKey = GlobalKey();
  int currentPage = 1;

  // @override
  // void didUpdateWidget(ProductReviews oldWidget) {
  //   pageController.refresh();
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void initState() {
    super.initState();
    pageController.addPageRequestListener((pageKey) {
      currentPage = pageKey;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(productAdapterProvider(productAdapterFamilyKey).notifier)
            .getProductReviews(
              productId: widget.product.id,
              page: pageKey,
            );
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      productAdapterProvider(productAdapterFamilyKey),
      (previous, next) {
        if (next is ProductError) {
          pageController.error = next.message;
          CoreUtils.showSnackBar(context, message: next.message);
        } else if (next is ReviewsFetched) {
          final reviews = next.reviews;
          final isLastPage = reviews.length < NetworkConstants.pageSize;
          if (isLastPage) {
            pageController.appendLastPage(reviews);
          } else {
            final nextPage = currentPage + 1;
            pageController.appendPage(reviews, nextPage);
          }
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        bottom: const AppBarBottom(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reviews (${widget.product.numberOfReviews})',
                    style: TextStyles.buttonTextHeadingSemiBold
                        .adaptiveColour(context),
                  ),
                  RatingStars(widget.product.rating),
                ],
              ),
              const Gap(30),
              Expanded(
                child: PagedListView<int, Review>.separated(
                  pagingController: pageController,
                  separatorBuilder: (_, __) => const Gap(30),
                  builderDelegate: PagedChildBuilderDelegate<Review>(
                    itemBuilder: (context, item, index) => ReviewTile(item),
                    firstPageProgressIndicatorBuilder: (_) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colours.lightThemePrimaryColour,
                        ),
                      );
                    },
                    newPageProgressIndicatorBuilder: (_) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colours.lightThemePrimaryColour,
                        ),
                      );
                    },
                    noItemsFoundIndicatorBuilder: (_) {
                      return const Center(
                        child: EmptyData(
                          'No reviews for this product.',
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
