import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';
import 'package:ecomly/src/product/domain/repos/product_repo.dart';

class GetCategories extends UsecaseWithoutParams<List<ProductCategory>> {
  const GetCategories(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<ProductCategory>> call() => _repo.getCategories();
}
