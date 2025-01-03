import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/domain/entities/review.dart';
import 'package:ecomly/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class GetProductReviews
    extends UsecaseWithParams<List<Review>, GetProductReviewsParams> {
  const GetProductReviews(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Review>> call(GetProductReviewsParams params) =>
      _repo.getProductReviews(
        productId: params.productId,
        page: params.page,
      );
}

class GetProductReviewsParams extends Equatable {
  const GetProductReviewsParams({
    required this.productId,
    required this.page,
  });

  final String productId;
  final int page;

  @override
  List<dynamic> get props => [
        productId,
        page,
      ];
}
