import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/common/widgets/classic_product_tile.dart';
import 'package:ecomly/core/common/widgets/empty_data.dart';
import 'package:ecomly/core/extensions/context_extensions.dart';
import 'package:ecomly/core/res/media.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/utils/enums/gender_age_category_enum.dart';
import 'package:ecomly/src/home/presentation/refactors/search_section.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';
import 'package:ecomly/src/product/presentation/app/category_riverpod_notifier/category_notifier.dart';
import 'package:ecomly/src/product/presentation/app/gender_age_category_riverpod_notifier/gender_age_category_notifier.dart';
import 'package:ecomly/src/product/presentation/app/product_riverpod_provider/product_provider.dart';
import 'package:ecomly/src/product/presentation/widgets/category_selector.dart';
import 'package:ecomly/src/product/presentation/widgets/gender_age_category_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/majesticons.dart';
import 'package:lottie/lottie.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  static const path = '/search';

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final categoryFamilyKey = GlobalKey();
  final genderAgeCategoryFamilyKey = GlobalKey();
  final productAdapterFamilyKey = GlobalKey();
  final searchController = TextEditingController();

  int page = 1;

  final typingNotifier = ValueNotifier(false);

  void search({
    required ProductCategory category,
    required GenderAgeCategory genderAgeCategory,
  }) {
    typingNotifier.value = false;
    final productAdapter =
        ref.read(productAdapterProvider(productAdapterFamilyKey).notifier);
    if (category.name!.toLowerCase() != 'all') {
      // means that the genderAgeCategory is considered
      if (genderAgeCategory.title.toLowerCase() != 'all') {
        // means we have a specification and they are
        // both not [all]
        productAdapter.searchByCategoryAndGenderAgeCategory(
          query: searchController.text.trim(),
          categoryId: category.id,
          genderAgeCategory: genderAgeCategory.title.toLowerCase(),
          page: page,
        );
      } else {
        // means we have only category specified
        productAdapter.searchByCategory(
          query: searchController.text.trim(),
          categoryId: category.id,
          page: page,
        );
      }
    } else {
      productAdapter.searchAllProducts(
        query: searchController.text.trim(),
        page: page,
      );
    }
  }

  Widget body({
    required ProductState productAdapter,
    required ProductCategory category,
    required GenderAgeCategory genderAgeCategory,
  }) {
    if (productAdapter is Searching) {
      return Center(child: Lottie.asset(Media.searching));
    } else if (productAdapter is ProductsFetched) {
      var products = productAdapter.products;
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
    return Center(
      child: Lottie.asset(
        context.isDarkMode ? Media.search : Media.searchLight,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => typingNotifier.value = true);
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(categoryNotifierProvider(categoryFamilyKey));
    final productAdapter = ref.watch(
      productAdapterProvider(productAdapterFamilyKey),
    );
    final genderAgeCategory = ref.watch(
      genderAgeCategoryNotifierProvider(genderAgeCategoryFamilyKey),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: const AppBarBottom(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(top: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SearchSection(
                    controller: searchController,
                    suffixIcon: IconButton(
                      onPressed: () => search(
                        category: category,
                        genderAgeCategory: genderAgeCategory,
                      ),
                      icon: const Iconify(
                        Majesticons.send,
                        color: Colours.lightThemePrimaryColour,
                      ),
                    ),
                  ),
                  const Gap(20),
                  CategorySelector(
                    selectedCategory: category,
                    onSelected: (category) {
                      ref
                          .read(
                            categoryNotifierProvider(
                              categoryFamilyKey,
                            ).notifier,
                          )
                          .changeCategory(category);
                    },
                  ),
                  const Gap(10),
                  if (category.name!.toLowerCase() != 'all') ...[
                    GenderAgeCategorySelector(
                      selectedGenderAgeCategory: genderAgeCategory,
                      onSelected: (category) {
                        ref
                            .read(
                              genderAgeCategoryNotifierProvider(
                                genderAgeCategoryFamilyKey,
                              ).notifier,
                            )
                            .changeCategory(category);
                      },
                    ),
                    const Gap(10),
                  ]
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: typingNotifier,
                  builder: (_, typing, __) {
                    if (typing) {
                      return Center(child: Lottie.asset(Media.searching));
                    }
                    return body(
                      productAdapter: productAdapter,
                      category: category,
                      genderAgeCategory: genderAgeCategory,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
