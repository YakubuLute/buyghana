import 'dart:convert';

import 'package:ecomly/core/common/models/error_reponse.dart';
import 'package:ecomly/core/common/singletons/cache.dart';
import 'package:ecomly/core/errors/exceptions.dart';
import 'package:ecomly/core/extensions/string_extensions.dart';
import 'package:ecomly/core/utils/constants/network_constants.dart';
import 'package:ecomly/core/utils/network_utils.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/wishlist/data/models/wishlist_product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class WishlistRemoteDataSrc {
  Future<List<WishlistProductModel>> getWishlist(String userId);

  Future<void> addToWishlist({
    required String userId,
    required String productId,
  });

  Future<void> removeFromWishlist({
    required String userId,
    required String productId,
  });
}

class WishlistRemoteDataSrcImpl implements WishlistRemoteDataSrc {
  const WishlistRemoteDataSrcImpl(this._client);

  final http.Client _client;

  @override
  Future<List<WishlistProductModel>> getWishlist(String userId) async {
    try {
      final uri = Uri.http(
        NetworkConstants.authority,
        '${NetworkConstants.apiUrl}${_userWishlistEndpoint(userId)}',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toHeaders,
      );
      final payload = jsonDecode(response.body);
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        payload as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      payload as List<dynamic>;
      return payload
          .cast<DataMap>()
          .map(
            (wishlistProduct) => WishlistProductModel.fromMap(wishlistProduct),
          )
          .toList();
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> addToWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      final uri = Uri.http(
        NetworkConstants.authority,
        '${NetworkConstants.apiUrl}${_userWishlistEndpoint(userId)}',
      );

      final response = await _client.post(
        uri,
        headers: Cache.instance.sessionToken!.toHeaders,
        body: jsonEncode({'productId': productId}),
      );
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200 && response.statusCode != 201) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> removeFromWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      final uri = Uri.http(
        NetworkConstants.authority,
        '${NetworkConstants.apiUrl}${_userWishlistEndpoint(userId)}/$productId',
      );

      final response = await _client.delete(
        uri,
        headers: Cache.instance.sessionToken!.toHeaders,
      );
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200 && response.statusCode != 204) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  String _userWishlistEndpoint(String userId) {
    return '/users/$userId/wishlist';
  }
}
