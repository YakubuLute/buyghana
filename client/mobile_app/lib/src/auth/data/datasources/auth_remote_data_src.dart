// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:buyghana/core/common/app/cache_helper.dart';
import 'package:buyghana/core/common/models/error_reponse.dart';
import 'package:buyghana/core/common/singletons/cache.dart';
import 'package:buyghana/core/errors/exceptions.dart';
import 'package:buyghana/core/extensions/string_extensions.dart';
import 'package:buyghana/core/services/injection_container.dart';
import 'package:buyghana/core/utils/constants/network_constants.dart';
import 'package:buyghana/core/utils/network_utils.dart';
import 'package:buyghana/core/utils/typedefs.dart';
import 'package:buyghana/src/user/data/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSrc {
  const AuthRemoteDataSrc();

  Future<void> register({
    required String name,
    required String password,
    required String email,
    required String phone,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<void> forgotPassword(String email);

  Future<void> verifyOTP({
    required String email,
    required String otp,
  });

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });

  Future<bool> verifyToken();
}

const REGISTER_ENDPOINT = '/auth/register';
const LOGIN_ENDPOINT = '/auth/login';
const FORGOT_PASSWORD_ENDPOINT = '/auth/forgot-password';
const VERIFY_OTP_ENDPOINT = '/auth/verify-otp';
const RESET_PASSWORD_ENDPOINT = '/auth/reset-password';
const VERIFY_TOKEN_ENDPOINT = '/auth/verify-token';

class AuthRemoteDataSrcImpl implements AuthRemoteDataSrc {
  const AuthRemoteDataSrcImpl(this._client);

  final http.Client _client;

  @override
  Future<void> register({
    required String name,
    required String password,
    required String email,
    required String phone,
  }) async {
    try {
      final uri = Uri.parse('${NetworkConstants.baseUrl}$REGISTER_ENDPOINT');

      final response = await _client.post(
        uri,
        body: jsonEncode({
          'name': name,
          'password': password,
          'email': email,
          'phone': phone,
        }),
        headers: NetworkConstants.headers,
      );
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

  // @override
  // Future<UserModel> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final uri = Uri.parse('${NetworkConstants.baseUrl}$LOGIN_ENDPOINT');

  //     final response = await _client.post(
  //       uri,
  //       body: jsonEncode({'password': password, 'email': email}),
  //       headers: NetworkConstants.headers,
  //     );
  //     final payload = jsonDecode(response.body) as DataMap;
  //     print("Payload:  $payload");
  //     if (response.statusCode != 200) {
  //       final errorResponse = ErrorResponse.fromMap(payload);
  //       throw ServerException(
  //         message: errorResponse.errorMessage,
  //         statusCode: response.statusCode,
  //       );
  //     }
  //     await sl<CacheHelper>().cacheSessionToken(payload['accessToken']);
  //     final user = UserModel.fromMap(payload);
  //     await sl<CacheHelper>().cacheUserId(user.id);
  //     return user;
  //   } on ServerException {
  //     rethrow;
  //   } catch (e, s) {
  //     print("Error login in: ====================== $e");
  //     debugPrint(e.toString());
  //     debugPrintStack(stackTrace: s);
  //     throw ServerException(message: e.toString(), statusCode: 500);
  //   }
  // }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('${NetworkConstants.baseUrl}$LOGIN_ENDPOINT');

      final response = await _client.post(
        uri,
        body: jsonEncode({'password': password, 'email': email}),
        headers: NetworkConstants.headers,
      );

      final payload = jsonDecode(response.body) as DataMap;
      print("Payload:  $payload");

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }

      // Cache the tokens
      await sl<CacheHelper>()
          .cacheSessionToken(payload['accessToken'] as String);

      // Create user model from the nested user data
      final userData = payload['user'] as DataMap;
      final user = UserModel.fromMap(userData);

      await sl<CacheHelper>().cacheUserId(user.id);
      return user;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      print("Error login in: ====================== $e");
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$FORGOT_PASSWORD_ENDPOINT',
      );

      final response = await _client.post(
        uri,
        body: jsonEncode({'email': email}),
        headers: NetworkConstants.headers,
      );
      if (response.statusCode != 200) {
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
  Future<void> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$VERIFY_OTP_ENDPOINT',
      );

      final response = await _client.post(
        uri,
        body: jsonEncode({'email': email, 'otp': otp}),
        headers: NetworkConstants.headers,
      );
      if (response.statusCode != 200) {
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
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$RESET_PASSWORD_ENDPOINT',
      );

      final response = await _client.post(
        uri,
        body: jsonEncode({'email': email, 'newPassword': newPassword}),
        headers: NetworkConstants.headers,
      );
      if (response.statusCode != 200) {
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
  Future<bool> verifyToken() async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$VERIFY_TOKEN_ENDPOINT',
      );
      debugPrint('ACCESS TOKEN: ${Cache.instance.sessionToken}');
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
      return payload as bool;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
