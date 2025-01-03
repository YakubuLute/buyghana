import 'package:ecomly/core/utils/enums/gender_age_category_enum.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gender_age_category_notifier.g.dart';

@riverpod
class GenderAgeCategoryNotifier extends _$GenderAgeCategoryNotifier {
  @override
  GenderAgeCategory build([GlobalKey? familyKey]) {
    return GenderAgeCategory.all;
  }

  void changeCategory(GenderAgeCategory category) {
    if (state != category) state = category;
  }
}
