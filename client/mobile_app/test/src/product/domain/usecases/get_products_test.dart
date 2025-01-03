import 'package:dartz/dartz.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/domain/usecases/get_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'product_repo.mock.dart';

void main() {
  late MockProductRepo repo;
  late GetProducts usecase;

  const tPage = 1;
  const tResult = <Product>[Product.empty()];

  setUp(() {
    repo = MockProductRepo();
    usecase = GetProducts(repo);
    registerFallbackValue(tPage);
  });

  test(
    'should return [List<Product>] from the repo',
    () async {
      when(() => repo.getProducts(any())).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(tPage);
      expect(result, equals(const Right<dynamic, List<Product>>(tResult)));
      verify(() => repo.getProducts(any())).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
