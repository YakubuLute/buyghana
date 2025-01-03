import 'package:ecomly/core/common/app/cache_helper.dart';
import 'package:ecomly/core/common/singletons/cache.dart';
import 'package:ecomly/core/extensions/context_extensions.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/extensions/widget_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/services/injection_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ThemeToggle extends StatefulWidget {
  const ThemeToggle({super.key});

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle> {
  late double value;
  bool caching = false;

  String label() {
    return switch (value) {
      .0 => 'Light',
      .5 => 'Dark',
      _ => 'System',
    };
  }

  Future<void> cache(double newValue) async {
    setState(() {
      caching = true;
    });
    await sl<CacheHelper>().cacheThemeMode(
      switch (newValue) {
        .0 => ThemeMode.light,
        .5 => ThemeMode.dark,
        _ => ThemeMode.system,
      },
    );
    setState(() {
      caching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    switch (Cache.instance.themeModeNotifier.value) {
      case ThemeMode.light:
        value = 0.0;
      case ThemeMode.dark:
        value = 0.5;
      default:
        value = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(0, 0),
                    end: Offset(
                      0,
                      animation.value,
                    ),
                  ),
                ),
                child: child,
              ),
            );
          },
          child: GestureDetector(
            key: UniqueKey(),
            onTap: () async {
              setState(() {
                switch (value) {
                  case .0:
                    value = .5;
                  case .5:
                    value = 1;
                  case 1:
                    value = .0;
                }
              });
              await cache(value);
            },
            child: Row(
              children: [
                Icon(
                  switch (value) {
                    .0 => Icons.light_mode,
                    .5 => Icons.dark_mode,
                    _ => switch (defaultTargetPlatform) {
                        TargetPlatform.iOS => Icons.phone_iphone_rounded,
                        TargetPlatform.android ||
                        TargetPlatform.fuchsia =>
                          Icons.phone_android_rounded,
                        TargetPlatform.linux => Icons.laptop_chromebook_rounded,
                        TargetPlatform.windows => Icons.laptop_windows_rounded,
                        TargetPlatform.macOS => Icons.laptop_mac_rounded,
                      }
                  },
                  color: context.isDarkMode
                      ? Colours.lightThemeSecondaryTextColour
                      : Colors.yellow,
                ),
                const Gap(2),
                Text(
                  label(),
                  style: TextStyles.paragraphSubTextRegular2
                      .adaptiveColour(context),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Theme(
            data: ThemeData(),
            child: Slider.adaptive(
              value: value,
              label: label(),
              divisions: 2,
              onChanged: (newValue) async {
                setState(() {
                  value = newValue;
                });
                await cache(newValue);
              },
            ).loading(caching),
          ),
        ),
      ],
    );
  }
}
