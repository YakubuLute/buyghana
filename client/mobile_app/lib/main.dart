import 'package:device_preview/device_preview.dart';
import 'package:ecomly/core/common/app/cache_helper.dart';
import 'package:ecomly/core/common/singletons/cache.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/services/injection_container.dart';
import 'package:ecomly/core/services/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  sl<CacheHelper>().getThemeMode();
  runApp(
    DevicePreview(
      enabled: defaultTargetPlatform != TargetPlatform.android &&
          defaultTargetPlatform != TargetPlatform.iOS,
      builder: (context) => const ProviderScope(child: App()),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colours.lightThemePrimaryColour,
      ),
      fontFamily: 'Switzer',
      scaffoldBackgroundColor: Colours.lightThemeTintStockColour,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colours.lightThemeTintStockColour,
          foregroundColor: Colours.lightThemePrimaryTextColour),
      useMaterial3: true,
    );
    return ValueListenableBuilder(
        valueListenable: Cache.instance.themeModeNotifier,
        builder: (_, themeMode, __) {
          return MaterialApp.router(
            routerConfig: router,
            title: 'Ecomly',
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            themeMode: themeMode,
            theme: theme,
            darkTheme: theme.copyWith(
                scaffoldBackgroundColor: Colours.darkThemeBGDark,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colours.darkThemeBGDark,
                  foregroundColor: Colours.lightThemeWhiteColour,
                )),
          );
        });
  }
}
