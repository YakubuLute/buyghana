import 'package:ecomly/src/home/presentation/refactors/categories_section.dart';
import 'package:ecomly/src/home/presentation/refactors/home_app_bar.dart';
import 'package:ecomly/src/home/presentation/refactors/search_section.dart';
import 'package:ecomly/src/home/presentation/widgets/product_section.dart';
import 'package:ecomly/src/home/presentation/widgets/promo_banner.dart';
import 'package:ecomly/src/product/presentation/views/all_new_arrivals_view.dart';
import 'package:ecomly/src/product/presentation/views/all_popular_products_view.dart';
import 'package:ecomly/src/product/presentation/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Gap(40),
            SearchSection(onTap: () => context.push(SearchView.path)),
            const Gap(20),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  const PromoBanner(),
                  const Gap(20),
                  const CategoriesSection(),
                  const Gap(20),
                  ProductsSection.popular(
                    onViewAll: () {
                      context.go(
                        '${HomeView.path}/${AllPopularProductsView.path}',
                      );
                    },
                  ),
                  const Gap(20),
                  ProductsSection.newArrivals(
                    onViewAll: () {
                      context.go('${HomeView.path}/${AllNewArrivalsView.path}');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
