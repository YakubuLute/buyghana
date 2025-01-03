// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:ecomly/core/common/models/error_reponse.dart';
import 'package:ecomly/core/common/singletons/cache.dart';
import 'package:ecomly/core/errors/exceptions.dart';
import 'package:ecomly/core/extensions/string_extensions.dart';
import 'package:ecomly/core/utils/constants/network_constants.dart';
import 'package:ecomly/core/utils/network_utils.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/order/data/models/order_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class OrderRemoteDataSrc {
  Future<OrderModel> getOrder(String orderId);

  Future<DataMap> getUserOrders(String userId);
}

const GET_ORDER_ENDPOINT = '/orders';

class OrderRemoteDataSrcImpl implements OrderRemoteDataSrc {
  const OrderRemoteDataSrcImpl(this._client);

  final http.Client _client;

  @override
  Future<OrderModel> getOrder(String orderId) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$GET_ORDER_ENDPOINT/$orderId',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toHeaders,
      );
      final payload = jsonDecode(response.body) as DataMap;
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      return OrderModel.fromMap(payload);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<DataMap> getUserOrders(String userId) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$GET_ORDER_ENDPOINT/user/$userId',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toHeaders,
      );
      final payload = jsonDecode(response.body) as DataMap;
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      payload['active'] = List<DataMap>.from(payload['active'] as List)
          .map(OrderModel.fromMap)
          .toList();
      payload['completed'] = List<DataMap>.from(payload['completed'] as List)
          .map(OrderModel.fromMap)
          .toList();
      payload['cancelled'] = List<DataMap>.from(payload['cancelled'] as List)
          .map(OrderModel.fromMap)
          .toList();
      return payload;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
