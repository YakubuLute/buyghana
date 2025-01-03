import 'package:ecomly/core/common/widgets/classic_product_tile.dart';
import 'package:ecomly/core/common/widgets/empty_data.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/core/utils/enums/product_criteria_enum.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';
import 'package:ecomly/src/product/presentation/app/category_riverpod_notifier/category_notifier.dart';
import 'package:ecomly/src/product/presentation/app/product_riverpod_provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorizedProductsByCriteriaView extends ConsumerStatefulWidget {
  const CategorizedProductsByCriteriaView({
    required this.categoryAdapterFamilyKey,
    required this.productCriteria,
    super.key,
  }) : assert(productCriteria == ProductCriteria.newArrivals ||
            productCriteria == ProductCriteria.popular);

  final GlobalKey categoryAdapterFamilyKey;
  final ProductCriteria productCriteria;

  @override
  ConsumerState createState() => _DynamicProductsViewState();
}

class _DynamicProductsViewState
    extends ConsumerState<CategorizedProductsByCriteriaView> {
  final familyKey = GlobalKey();
  int page = 1;

  Future<void> getProducts() async {
    final category = ref.watch(
      categoryNotifierProvider(widget.categoryAdapterFamilyKey),
    );
    if (widget.productCriteria == ProductCriteria.newArrivals) {
      return ref
          .read(productAdapterProvider(familyKey).notifier)
          .getNewArrivals(
            page: page,
            categoryId:
                category.name?.toLowerCase() == 'all' ? null : category.id,
          );
    }
    return ref.read(productAdapterProvider(familyKey).notifier).getPopular(
          page: page,
          categoryId:
              category.name?.toLowerCase() == 'all' ? null : category.id,
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProducts();
    });
  }

  Widget body({
    required ProductState productAdapter,
    required ProductCategory category,
  }) {
    if (productAdapter is FetchingProducts) {
      return const Center(
          child: CircularProgressIndicator.adaptive(
        backgroundColor: Colours.lightThemePrimaryColour,
      ));
    } else if (productAdapter is ProductsFetched) {
      var products = productAdapter.products;
      if (category.name != 'All') {
        products = products
            .where((product) => product.category.id == category.id)
            .toList();
      }
      if (products.isEmpty) {
        return const Center(child: EmptyData('No Products Found'));
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SingleChildScrollView(
          child: Center(
            child: Wrap(
              runSpacing: 10,
              runAlignment: WrapAlignment.center,
              spacing: 10,
              children: products
                  .map((product) => ClassicProductTile(product))
                  .toList(),
            ),
          ),
        ),
      );
    } else if (productAdapter is ProductError) {
      return const EmptyData('No Products Found');
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final productAdapter = ref.watch(productAdapterProvider(familyKey));
    final category = ref.watch(
      categoryNotifierProvider(widget.categoryAdapterFamilyKey),
    );
    ref.listen(productAdapterProvider(familyKey), (previous, next) {
      if (next is ProductError) {
        CoreUtils.showSnackBar(
          context,
          message: '${next.message}\nPULL TO REFRESH',
        );
      }
    });

    return RefreshIndicator.adaptive(
      onRefresh: getProducts,
      child: body(productAdapter: productAdapter, category: category),
    );
  }
}
