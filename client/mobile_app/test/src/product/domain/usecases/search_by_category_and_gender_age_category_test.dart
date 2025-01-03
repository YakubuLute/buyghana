import 'package:dartz/dartz.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/domain/usecases/search_by_category_and_gender_age_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'product_repo.mock.dart';

void main() {
  late MockProductRepo repo;
  late SearchByCategoryAndGenderAgeCategory usecase;

  const tQuery = 'Test String';

  const tCategoryId = 'Test String';

  const tGenderAgeCategory = 'Test String';

  const tPage = 1;
  const tResult = <Product>[Product.empty()];

  setUp(() {
    repo = MockProductRepo();
    usecase = SearchByCategoryAndGenderAgeCategory(repo);
    registerFallbackValue(tQuery);
    registerFallbackValue(tCategoryId);
    registerFallbackValue(tGenderAgeCategory);
    registerFallbackValue(tPage);
  });

  test(
    'should return [List<Product>] from the repo',
    () async {
      when(
        () => repo.searchByCategoryAndGenderAgeCategory(
          query: any(named: "query"),
          categoryId: any(named: "categoryId"),
          genderAgeCategory: any(named: "genderAgeCategory"),
          page: any(named: "page"),
        ),
      ).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(
        const SearchByCategoryAndGenderAgeCategoryParams(
          query: tQuery,
          categoryId: tCategoryId,
          genderAgeCategory: tGenderAgeCategory,
          page: tPage,
        ),
      );
      expect(result, equals(const Right<dynamic, List<Product>>(tResult)));
      verify(
        () => repo.searchByCategoryAndGenderAgeCategory(
          query: any(named: "query"),
          categoryId: any(named: "categoryId"),
          genderAgeCategory: any(named: "genderAgeCategory"),
          page: any(named: "page"),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
