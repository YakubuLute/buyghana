import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class SearchByCategory
    extends UsecaseWithParams<List<Product>, SearchByCategoryParams> {
  const SearchByCategory(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(SearchByCategoryParams params) =>
      _repo.searchByCategory(
        query: params.query,
        categoryId: params.categoryId,
        page: params.page,
      );
}

class SearchByCategoryParams extends Equatable {
  const SearchByCategoryParams({
    required this.query,
    required this.categoryId,
    required this.page,
  });

  final String query;
  final String categoryId;
  final int page;

  @override
  List<dynamic> get props => [
        query,
        categoryId,
        page,
      ];
}
