import 'package:buyghana/core/usecase/usecase.dart';
import 'package:buyghana/core/utils/typedefs.dart';
import 'package:buyghana/src/product/domain/entities/product.dart';
import 'package:buyghana/src/product/domain/repos/product_repo.dart';

class GetProducts extends UsecaseWithParams<List<Product>, int> {
  const GetProducts(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(int params) => _repo.getProducts(params);
}
