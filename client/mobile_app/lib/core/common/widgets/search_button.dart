import 'package:ecomly/src/product/presentation/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key, this.padding});

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: IconButton(
        onPressed: () => context.push(SearchView.path),
        icon: const Icon(IconlyBroken.search),
      ),
    );
  }
}
