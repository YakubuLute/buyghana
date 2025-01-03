import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/common/widgets/search_button.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';
import 'package:ecomly/src/product/presentation/app/product_riverpod_provider/product_provider.dart';
import 'package:ecomly/src/product/presentation/widgets/dynamic_products_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorizedProductsView extends ConsumerStatefulWidget {
  const CategorizedProductsView(this.category, {super.key});

  final ProductCategory category;

  @override
  ConsumerState createState() => _CategorizedProductsViewState();
}

class _CategorizedProductsViewState
    extends ConsumerState<CategorizedProductsView> {
  final familyKey = GlobalKey();

  Future<void> getProducts(int page) async {
    return ref
        .read(productAdapterProvider(familyKey).notifier)
        .getProductsByCategory(
          categoryId: widget.category.id,
          page: page,
        );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name!),
        bottom: const AppBarBottom(),
        actions: const [SearchButton(padding: EdgeInsets.only(right: 10))],
      ),
      body: SafeArea(
        child: DynamicProductsView(
          productAdapterFamilyKey: familyKey,
          fetchRequest: getProducts,
          categorized: false,
        ),
      ),
    );
  }
}
