import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/product/presentation/app/product_riverpod_provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CategoriesSection extends ConsumerStatefulWidget {
  const CategoriesSection({super.key});

  @override
  ConsumerState<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends ConsumerState<CategoriesSection> {
  final familyKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    CoreUtils.postFrameCall(() =>
        ref.read(productAdapterProvider(familyKey).notifier).getCategories());
  }

  @override
  Widget build(BuildContext context) {
    final productAdapter = ref.watch(productAdapterProvider(familyKey));
    ref.listen(productAdapterProvider(familyKey), (previous, next) {
      if (next is ProductError) {
        CoreUtils.showSnackBar(context, message: next.message);
      }
    });
    if (productAdapter is FetchingCategories) {
      return const Center(
          child: CircularProgressIndicator.adaptive(
        backgroundColor: Colours.lightThemePrimaryColour,
      ));
    } else if (productAdapter is CategoriesFetched) {
      return SizedBox(
        height: 95,
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          scrollDirection: Axis.horizontal,
          itemCount: productAdapter.categories.take(10).length,
          separatorBuilder: (_, __) => const Gap(20),
          itemBuilder: (context, index) {
            final category = productAdapter.categories[index];
            return GestureDetector(
              onTap: () {
                context.push('/${category.name}', extra: category);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 31,
                    backgroundColor: Colours.lightThemeSecondaryTextColour,
                    backgroundImage: NetworkImage(category.image!),
                  ),
                  const Gap(3),
                  Text(
                    category.name!,
                    style: TextStyles.paragraphSubTextRegular1
                        .adaptiveColour(context),
                  )
                ],
              ),
            );
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
