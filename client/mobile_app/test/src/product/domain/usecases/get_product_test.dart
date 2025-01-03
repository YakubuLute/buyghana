import 'package:dartz/dartz.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/domain/usecases/get_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'product_repo.mock.dart';

void main() {
  late MockProductRepo repo;
  late GetProduct usecase;

  const tProductId = 'Test String';

  const tResult = Product.empty();

  setUp(() {
    repo = MockProductRepo();
    usecase = GetProduct(repo);
    registerFallbackValue(tProductId);
  });

  test(
    'should return [Product] from the repo',
    () async {
      when(() => repo.getProduct(any())).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(tProductId);
      expect(result, equals(const Right<dynamic, Product>(tResult)));
      verify(() => repo.getProduct(any())).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
