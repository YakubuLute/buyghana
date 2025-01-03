import 'package:ecomly/core/common/widgets/classic_product_tile.dart';
import 'package:ecomly/core/common/widgets/empty_data.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/utils/constants/network_constants.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/presentation/app/category_riverpod_notifier/category_notifier.dart';
import 'package:ecomly/src/product/presentation/app/product_riverpod_provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DynamicProductsView extends ConsumerStatefulWidget {
  const DynamicProductsView({
    required this.productAdapterFamilyKey,
    this.categoryFamilyKey,
    required this.fetchRequest,
    this.categorized = true,
    super.key,
  }) : assert(
          !categorized || (categorized && categoryFamilyKey != null),
          'Category family key cannot be null in a "Categorized" products view',
        );

  final GlobalKey productAdapterFamilyKey;
  final GlobalKey? categoryFamilyKey;
  final ValueChanged<int> fetchRequest;
  final bool categorized;

  @override
  ConsumerState<DynamicProductsView> createState() => _DynamicProductsView();
}

class _DynamicProductsView extends ConsumerState<DynamicProductsView> {
  final pageController = PagingController<int, Product>(firstPageKey: 1);
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    debugPrint('booting');
    pageController.addPageRequestListener((pageKey) {
      currentPage = pageKey;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.fetchRequest(pageKey);
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
      productAdapterProvider(widget.productAdapterFamilyKey),
      (previous, next) {
        if (next is ProductError) {
          pageController.error = next.message;
          // redundant
          CoreUtils.showSnackBar(
            context,
            message: '${next.message}\nPULL TO REFRESH',
          );
        } else if (next is ProductsFetched) {
          final products = next.products;
          final isLastPage = products.length < NetworkConstants.pageSize;
          if (isLastPage) {
            pageController.appendLastPage(products);
          } else {
            final nextPage = currentPage + 1;
            pageController.appendPage(products, nextPage);
          }
        }
      },
    );
    final category =
        ref.watch(categoryNotifierProvider(widget.categoryFamilyKey));

    ref.listen(
      categoryNotifierProvider(widget.categoryFamilyKey),
      (previous, next) {
        // TODO(Manual-Reset): Check if necessary when there's enough products
        // because I think the pageController.refresh will actually reset
        // everything, including the currentPage, but I'm not sure, I can't
        // verify this either as I don't have enough products to exceed a page
        currentPage = 1;
        pageController.refresh();
      },
    );

    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => pageController.refresh(),
      ),
      child: PagedMasonryGridView<int, Product>.count(
        pagingController: pageController,
        crossAxisCount: 2,
        builderDelegate: PagedChildBuilderDelegate<Product>(
          itemBuilder: (context, product, index) => Center(
            child: ClassicProductTile(product),
          ),
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
            final categorySelected =
                widget.categorized && category.name?.toLowerCase() != 'all';
            return Center(
              child: EmptyData(
                categorySelected
                    ? 'No products found for this category'
                    : 'No products found',
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}
