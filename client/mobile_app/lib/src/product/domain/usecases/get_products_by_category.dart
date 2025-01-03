import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class GetProductsByCategory
    extends UsecaseWithParams<List<Product>, GetProductsByCategoryParams> {
  const GetProductsByCategory(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(GetProductsByCategoryParams params) =>
      _repo.getProductsByCategory(
        categoryId: params.categoryId,
        page: params.page,
      );
}

class GetProductsByCategoryParams extends Equatable {
  const GetProductsByCategoryParams({
    required this.categoryId,
    required this.page,
  });

  final String categoryId;
  final int page;

  @override
  List<dynamic> get props => [
        categoryId,
        page,
      ];
}
