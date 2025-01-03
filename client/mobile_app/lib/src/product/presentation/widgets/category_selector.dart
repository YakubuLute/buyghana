import 'package:ecomly/core/extensions/context_extensions.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';
import 'package:ecomly/src/product/presentation/app/product_riverpod_provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CategorySelector extends ConsumerStatefulWidget {
  const CategorySelector({
    required this.onSelected,
    required this.selectedCategory,
    super.key,
    this.popWhenEmpty = false,
  });

  /// if the page depends heavily on the categories, then you might want to
  /// set this to true
  final bool popWhenEmpty;
  final ValueChanged<ProductCategory> onSelected;
  final ProductCategory selectedCategory;

  @override
  ConsumerState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends ConsumerState<CategorySelector> {
  final familyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productAdapterProvider(familyKey).notifier).getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adapterState = ref.watch(productAdapterProvider(familyKey));

    ref.listen(productAdapterProvider(familyKey), (previous, next) {
      if (next is ProductError) {
        CoreUtils.showSnackBar(context, message: next.message);
        CoreUtils.postFrameCall(context.pop);
      } else if (next is CategoriesFetched &&
          widget.popWhenEmpty &&
          next.categories.isEmpty) {
        CoreUtils.showSnackBar(
          context,
          message: 'No categories found.\nContact admin',
        );
        CoreUtils.postFrameCall(context.pop);
      }
    });

    if (adapterState is FetchingCategories) {
      return const LinearProgressIndicator();
    } else if (adapterState is CategoriesFetched) {
      return SizedBox(
        height: 40,
        child: Theme(
          data: context.theme.copyWith(canvasColor: Colors.transparent),
          child: ListView.separated(
            controller: ScrollController(),
            scrollDirection: Axis.horizontal,
            itemCount: adapterState.categories.length + 1,
            separatorBuilder: (_, __) => const Gap(10),
            itemBuilder: (context, index) {
              if (index == 0) {
                final selected =
                    widget.selectedCategory.name!.toLowerCase() == 'all';
                return ChoiceChip(
                  label: const Text('All'),
                  labelStyle: selected
                      ? TextStyles.headingSemiBold1.white
                      : TextStyles.paragraphSubTextRegular1.grey,
                  selected: selected,
                  selectedColor: Colours.lightThemePrimaryColour,
                  showCheckmark: false,
                  backgroundColor: Colors.transparent,
                  onSelected: (_) {
                    widget.onSelected(const ProductCategory.all());
                  },
                );
              }
              final category = adapterState.categories[index - 1];
              final selected = widget.selectedCategory == category;
              return ChoiceChip(
                label: Text(category.name!),
                labelStyle: selected
                    ? TextStyles.headingSemiBold1.white
                    : TextStyles.paragraphSubTextRegular1.grey,
                selected: selected,
                selectedColor: Colours.lightThemePrimaryColour,
                showCheckmark: false,
                backgroundColor: Colors.transparent,
                onSelected: (_) {
                  widget.onSelected(adapterState.categories[index - 1]);
                },
              );
            },
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
