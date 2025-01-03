import 'package:ecomly/core/extensions/context_extensions.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/enums/gender_age_category_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class GenderAgeCategorySelector extends ConsumerWidget {
  const GenderAgeCategorySelector({
    required this.onSelected,
    required this.selectedGenderAgeCategory,
    super.key,
  });

  final ValueChanged<GenderAgeCategory> onSelected;
  final GenderAgeCategory selectedGenderAgeCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 40,
      child: Theme(
        data: context.theme.copyWith(canvasColor: Colors.transparent),
        child: ListView.separated(
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          itemCount: GenderAgeCategory.values.length,
          separatorBuilder: (_, __) => const Gap(10),
          itemBuilder: (context, index) {
            final category = GenderAgeCategory.values[index];
            final selected = selectedGenderAgeCategory == category;
            return ChoiceChip(
              label: Text(category.title),
              labelStyle: selected
                  ? TextStyles.headingSemiBold1.white
                  : TextStyles.paragraphSubTextRegular1.grey,
              selected: selected,
              selectedColor: Colours.lightThemePrimaryColour,
              showCheckmark: false,
              backgroundColor: Colors.transparent,
              onSelected: (_) {
                onSelected(category);
              },
            );
          },
        ),
      ),
    );
  }
}
