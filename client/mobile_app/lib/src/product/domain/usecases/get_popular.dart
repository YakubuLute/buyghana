import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class GetPopular extends UsecaseWithParams<List<Product>, GetPopularParams> {
  const GetPopular(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(GetPopularParams params) => _repo.getPopular(
        page: params.page,
        categoryId: params.categoryId,
      );
}

class GetPopularParams extends Equatable {
  const GetPopularParams({
    required this.page,
    this.categoryId,
  });

  final int page;
  final String? categoryId;

  @override
  List<Object?> get props => [page, categoryId];
}
