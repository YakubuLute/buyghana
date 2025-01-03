import 'package:dartz/dartz.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/domain/usecases/get_popular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'product_repo.mock.dart';

void main() {
  late MockProductRepo repo;
  late GetPopular usecase;

  const tPage = 1;
  const tResult = <Product>[Product.empty()];

  setUp(() {
    repo = MockProductRepo();
    usecase = GetPopular(repo);
    registerFallbackValue(tPage);
  });

  test(
    'should return [List<Product>] from the repo',
    () async {
      when(
        () => repo.getPopular(
          page: any(named: 'page'),
          categoryId: any(named: 'categoryId'),
        ),
      ).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(const GetPopularParams(page: tPage));
      expect(result, equals(const Right<dynamic, List<Product>>(tResult)));
      verify(() => repo.getPopular(page: tPage, categoryId: null)).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
