import 'package:ecomly/core/extensions/context_extensions.dart';
import 'package:ecomly/src/home/presentation/refactors/search_section.dart';
import 'package:flutter/material.dart';

abstract class ProductUtils {
  const ProductUtils();

  static Widget buildShuttle(
    BuildContext context,
    Animation<double> __,
    HeroFlightDirection ___,
    BuildContext ____,
    BuildContext _____,
  ) {
    return Material(
        color: context.theme.scaffoldBackgroundColor,
        child: const SearchSection(readOnly: true));
  }
}
