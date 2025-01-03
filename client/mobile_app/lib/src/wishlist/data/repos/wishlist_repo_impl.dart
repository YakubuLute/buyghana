import 'package:dartz/dartz.dart';
import 'package:ecomly/core/errors/exceptions.dart';
import 'package:ecomly/core/errors/failures.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/wishlist/data/datasources/wishlist_remote_data_src.dart';
import 'package:ecomly/src/wishlist/domain/entities/wishlist_product.dart';
import 'package:ecomly/src/wishlist/domain/repos/wishlist_repo.dart';

class WishlistRepoImpl implements WishlistRepo {
  const WishlistRepoImpl(this._remoteDataSource);

  final WishlistRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<WishlistProduct>> getWishlist(String userId) async {
    try {
      final result = await _remoteDataSource.getWishlist(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> addToWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      await _remoteDataSource.addToWishlist(
          userId: userId, productId: productId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> removeFromWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      await _remoteDataSource.removeFromWishlist(
          userId: userId, productId: productId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
