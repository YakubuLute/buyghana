import 'package:collection/collection.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/home/presentation/widgets/home_product_tile.dart';
import 'package:ecomly/src/product/presentation/app/product_riverpod_provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';

class ProductsSection extends ConsumerStatefulWidget {
  const ProductsSection.newArrivals({super.key, this.onViewAll})
      : sectionTitle = 'New Arrivals',
        productsCriteria = 'newArrivals';

  const ProductsSection.popular({super.key, this.onViewAll})
      : sectionTitle = 'Popular Products',
        productsCriteria = 'popular';

  final String sectionTitle;
  final String productsCriteria;
  final VoidCallback? onViewAll;

  @override
  ConsumerState<ProductsSection> createState() => _ProductSectionState();
}

class _ProductSectionState extends ConsumerState<ProductsSection> {
  final familyKey = GlobalKey();

  void getPopular(int page) {
    ref.read(productAdapterProvider(familyKey).notifier).getPopular(page: page);
  }

  void getNewArrivals(int page) {
    ref
        .read(productAdapterProvider(familyKey).notifier)
        .getNewArrivals(page: page);
  }

  @override
  void initState() {
    super.initState();
    CoreUtils.postFrameCall(() {
      if (widget.productsCriteria == 'popular') {
        getPopular(1);
      } else if (widget.productsCriteria == 'newArrivals') {
        getNewArrivals(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productAdapter = ref.watch(productAdapterProvider(familyKey));
    ref.listen(productAdapterProvider(familyKey), (previous, next) {
      if (next is ProductError) {
        CoreUtils.showSnackBar(context, message: next.message);
      }
    });
    if (productAdapter is FetchingProducts) {
      return const Center(
          child: CircularProgressIndicator.adaptive(
        backgroundColor: Colours.lightThemePrimaryColour,
      ));
    } else if (productAdapter is ProductsFetched &&
        productAdapter.products.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.sectionTitle,
                style: TextStyles.buttonTextHeadingSemiBold
                    .adaptiveColour(context),
              ),
              if (productAdapter.products.length > 10)
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Colours.lightThemeSecondaryTextColour.withOpacity(.2),
                  ),
                  onPressed: widget.onViewAll,
                  icon: const Icon(
                    IconlyBroken.arrow_right,
                    color: Colours.lightThemeSecondaryColour,
                  ),
                ),
            ],
          ),
          const Gap(20),
          // I'm using this over listview because listview requires vertical
          // constraints, but this doesn't
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:
                  productAdapter.products.take(10).mapIndexed((index, product) {
                final isLast =
                    index == productAdapter.products.take(10).length - 1;
                return HomeProductTile(
                  product,
                  margin: isLast ? null : const EdgeInsets.only(right: 10),
                );
              }).toList(),
            ),
          )
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
