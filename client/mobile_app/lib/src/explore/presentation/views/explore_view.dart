import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/common/widgets/search_button.dart';
import 'package:ecomly/src/dashboard/presentation/widgets/menu_icon.dart';
import 'package:ecomly/src/product/presentation/app/category_riverpod_notifier/category_notifier.dart';
import 'package:ecomly/src/product/presentation/app/product_riverpod_provider/product_provider.dart';
import 'package:ecomly/src/product/presentation/widgets/category_selector.dart';
import 'package:ecomly/src/product/presentation/widgets/dynamic_products_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  static const path = '/explore';

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final productAdapterFamilyKey = GlobalKey();
  final categoryFamilyKey = GlobalKey();

  Future<void> getProducts(
    int page,
  ) async {
    final category = ref.watch(categoryNotifierProvider(categoryFamilyKey));
    final productAdapterNotifier =
        ref.read(productAdapterProvider(productAdapterFamilyKey).notifier);
    if (category.name?.toLowerCase() == 'all') {
      debugPrint('PAGE IS NOW $page FOR ALL');
      return productAdapterNotifier.getProducts(page);
    }
    debugPrint('PAGE IS NOW $page FOR ${category.name}');
    return productAdapterNotifier.getProductsByCategory(
      page: page,
      categoryId: category.id,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(categoryNotifierProvider(categoryFamilyKey));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        leading: const MenuIcon(),
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
                selectedCategory: category,
                onSelected: (category) {
                  ref
                      .read(
                        categoryNotifierProvider(categoryFamilyKey).notifier,
                      )
                      .changeCategory(category);
                },
              ),
            ),
            const Gap(20),
            Expanded(
              child: DynamicProductsView(
                productAdapterFamilyKey: productAdapterFamilyKey,
                categoryFamilyKey: categoryFamilyKey,
                fetchRequest: getProducts,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
