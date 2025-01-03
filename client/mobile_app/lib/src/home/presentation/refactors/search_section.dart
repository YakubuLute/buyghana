import 'package:ecomly/core/common/widgets/input_field.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/src/product/presentation/utils/product_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
    this.controller,
    super.key,
  });

  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  late TextEditingController controller;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '/search-section',
      flightShuttleBuilder: ProductUtils.buildShuttle,
      child: InputField(
        controller: controller,
        focusNode: focusNode,
        defaultValidation: false,
        hintText: 'Search for products',
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        prefixIcon: const Icon(IconlyLight.search),
        suffixIcon: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListenableBuilder(
                  listenable: focusNode,
                  builder: (context, _) {
                    return VerticalDivider(
                      color: focusNode.hasFocus
                          ? Colours.lightThemePrimaryColour
                          : Colours.lightThemeWhiteColour,
                      indent: 10,
                      endIndent: 10,
                      width: 20,
                    );
                  }),
              if (widget.suffixIcon != null)
                widget.suffixIcon!
              else
                const Icon(
                  IconlyLight.filter,
                  size: 18,
                )
            ],
          ),
        ),
      ),
    );
  }
}
