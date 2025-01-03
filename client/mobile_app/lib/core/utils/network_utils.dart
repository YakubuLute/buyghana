import 'package:ecomly/core/common/app/cache_helper.dart';
import 'package:ecomly/core/services/injection_container.dart';
import 'package:ecomly/core/services/router.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

abstract class NetworkUtils {
  const NetworkUtils();

  static Future<void> renewToken(Response response) async {
    if (response.headers['authorization'] != null) {
      debugPrint('EXPIRED... RENEWING');
      var token = response.headers['authorization'] as String;
      debugPrint('TOKEN: $token');
      if (token.startsWith('Bearer')) {
        token = token.replaceFirst('Bearer', '').trim();
      }
      await sl<CacheHelper>().cacheSessionToken(token);
    } else if (response.statusCode == 401) {
      rootNavigatorKey.currentContext?.go('/');
    }
  }
}
