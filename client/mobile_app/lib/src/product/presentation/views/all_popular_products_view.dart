import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/common/widgets/search_button.dart';
import 'package:ecomly/src/product/presentation/app/category_riverpod_notifier/category_notifier.dart';
import 'package:ecomly/src/product/presentation/app/product_riverpod_provider/product_provider.dart';
import 'package:ecomly/src/product/presentation/widgets/category_selector.dart';
import 'package:ecomly/src/product/presentation/widgets/dynamic_products_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AllPopularProductsView extends ConsumerStatefulWidget {
  const AllPopularProductsView({super.key});

  static const path = 'popular';

  @override
  ConsumerState createState() => _AllNewArrivalsViewState();
}

class _AllNewArrivalsViewState extends ConsumerState<AllPopularProductsView> {
  final categoryNotifierFamilyKey = GlobalKey();
  final productAdapterFamilyKey = GlobalKey();

  Future<void> getProducts(int page) async {
    final category =
        ref.watch(categoryNotifierProvider(categoryNotifierFamilyKey));
    String? categoryId;
    if (category.name?.toLowerCase() != 'all') {
      categoryId = category.id;
    }
    ref
        .read(productAdapterProvider(productAdapterFamilyKey).notifier)
        .getPopular(
          page: page,
          categoryId: categoryId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Products'),
        bottom: const AppBarBottom(),
        actions: const [SearchButton(padding: EdgeInsets.only(right: 10))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
              child: CategorySelector(
                selectedCategory: ref.watch(
                  categoryNotifierProvider(categoryNotifierFamilyKey),
                ),
                onSelected: (category) {
                  ref
                      .read(
                        categoryNotifierProvider(categoryNotifierFamilyKey)
                            .notifier,
                      )
                      .changeCategory(category);
                },
              ),
            ),
            const Gap(20),
            Expanded(
              child: DynamicProductsView(
                productAdapterFamilyKey: productAdapterFamilyKey,
                categoryFamilyKey: categoryNotifierFamilyKey,
                fetchRequest: getProducts,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
