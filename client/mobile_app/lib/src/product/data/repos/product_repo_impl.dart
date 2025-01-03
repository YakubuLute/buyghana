import 'package:dartz/dartz.dart';
import 'package:ecomly/core/errors/exceptions.dart';
import 'package:ecomly/core/errors/failures.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/data/datasources/product_remote_data_src.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/domain/entities/review.dart';
import 'package:ecomly/src/product/domain/repos/product_repo.dart';

class ProductRepoImpl implements ProductRepo {
  const ProductRepoImpl(this._remoteDataSource);

  final ProductRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<Product>> getProducts(int page) async {
    try {
      final result = await _remoteDataSource.getProducts(page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<Product> getProduct(String productId) async {
    try {
      final result = await _remoteDataSource.getProduct(productId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Product>> getProductsByCategory({
    required String categoryId,
    required int page,
  }) async {
    try {
      final result = await _remoteDataSource.getProductsByCategory(
          categoryId: categoryId, page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Product>> getNewArrivals({
    required int page,
    String? categoryId,
  }) async {
    try {
      final result = await _remoteDataSource.getNewArrivals(
        page: page,
        categoryId: categoryId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Product>> getPopular({
    required int page,
    String? categoryId,
  }) async {
    try {
      final result = await _remoteDataSource.getPopular(
        page: page,
        categoryId: categoryId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Product>> searchAllProducts({
    required String query,
    required int page,
  }) async {
    try {
      final result =
          await _remoteDataSource.searchAllProducts(query: query, page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Product>> searchByCategory({
    required String query,
    required String categoryId,
    required int page,
  }) async {
    try {
      final result = await _remoteDataSource.searchByCategory(
          query: query, categoryId: categoryId, page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Product>> searchByCategoryAndGenderAgeCategory({
    required String query,
    required String categoryId,
    required String genderAgeCategory,
    required int page,
  }) async {
    try {
      final result =
          await _remoteDataSource.searchByCategoryAndGenderAgeCategory(
              query: query,
              categoryId: categoryId,
              genderAgeCategory: genderAgeCategory,
              page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<ProductCategory>> getCategories() async {
    try {
      final result = await _remoteDataSource.getCategories();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<ProductCategory> getCategory(String categoryId) async {
    try {
      final result = await _remoteDataSource.getCategory(categoryId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> leaveReview({
    required String productId,
    required String userId,
    required String comment,
    required double rating,
  }) async {
    try {
      await _remoteDataSource.leaveReview(
          productId: productId,
          userId: userId,
          comment: comment,
          rating: rating);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Review>> getProductReviews({
    required String productId,
    required int page,
  }) async {
    try {
      final result = await _remoteDataSource.getProductReviews(
          productId: productId, page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
