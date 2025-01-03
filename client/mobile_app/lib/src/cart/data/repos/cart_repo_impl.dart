import 'package:dartz/dartz.dart';
import 'package:ecomly/core/errors/exceptions.dart';
import 'package:ecomly/core/errors/failures.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/cart/data/datasources/cart_remote_data_src.dart';
import 'package:ecomly/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly/src/cart/domain/repos/cart_repo.dart';

class CartRepoImpl implements CartRepo {
  const CartRepoImpl(this._remoteDataSource);

  final CartRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<CartProduct>> getCart(String userId) async {
    try {
      final result = await _remoteDataSource.getCart(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<int> getCartCount(String userId) async {
    try {
      final result = await _remoteDataSource.getCartCount(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<CartProduct> getCartProduct({
    required String userId,
    required String cartProductId,
  }) async {
    try {
      final result = await _remoteDataSource.getCartProduct(
        userId: userId,
        cartProductId: cartProductId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> addToCart({
    required String userId,
    required CartProduct cartProduct,
  }) async {
    try {
      await _remoteDataSource.addToCart(
        userId: userId,
        cartProduct: cartProduct,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> removeFromCart({
    required String userId,
    required String cartProductId,
  }) async {
    try {
      await _remoteDataSource.removeFromCart(
        userId: userId,
        cartProductId: cartProductId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> changeCartProductQuantity({
    required String userId,
    required String cartProductId,
    required int newQuantity,
  }) async {
    try {
      await _remoteDataSource.changeCartProductQuantity(
        userId: userId,
        cartProductId: cartProductId,
        newQuantity: newQuantity,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<String> initiateCheckout({
    required String theme,
    required List<CartProduct> cartItems,
  }) async {
    try {
      final result = await _remoteDataSource.initiateCheckout(
        theme: theme,
        cartItems: cartItems,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
