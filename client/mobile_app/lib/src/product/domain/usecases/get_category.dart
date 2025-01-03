import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';
import 'package:ecomly/src/product/domain/repos/product_repo.dart';

class GetCategory extends UsecaseWithParams<ProductCategory, String> {
  const GetCategory(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<ProductCategory> call(String params) =>
      _repo.getCategory(params);
}
