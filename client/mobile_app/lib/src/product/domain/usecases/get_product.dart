import 'package:buyghana/core/usecase/usecase.dart';
import 'package:buyghana/core/utils/typedefs.dart';
import 'package:buyghana/src/product/domain/entities/product.dart';
import 'package:buyghana/src/product/domain/repos/product_repo.dart';

class GetProduct extends UsecaseWithParams<Product, String> {
  const GetProduct(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<Product> call(String params) => _repo.getProduct(params);
}
