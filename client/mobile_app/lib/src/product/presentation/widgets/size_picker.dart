import 'package:ecomly/core/extensions/context_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SizePicker extends StatefulWidget {
  const SizePicker({
    required this.sizes,
    required this.radius,
    this.onSelect,
    this.canScroll = false,
    this.spacing,
    this.padding,
    super.key,
  });

  final List<String> sizes;
  final ValueChanged<String?>? onSelect;
  final double radius;
  final bool canScroll;
  final double? spacing;
  final EdgeInsetsGeometry? padding;

  @override
  State<SizePicker> createState() => _SizePickerState();
}

class _SizePickerState extends State<SizePicker> {
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(2),
        physics: widget.canScroll ? null : const NeverScrollableScrollPhysics(),
        itemCount: widget.sizes.length,
        separatorBuilder: (_, __) => Gap(widget.spacing ?? 2),
        itemBuilder: (context, index) {
          final size = widget.sizes[index];
          final isActive = selectedSize?.toLowerCase() == size.toLowerCase();
          return GestureDetector(
            onTap: () {
              String? activeSize = size;
              if (widget.onSelect != null) {
                if (selectedSize?.toLowerCase() == activeSize.toLowerCase()) {
                  activeSize = null;
                }
                widget.onSelect!(activeSize);
                setState(() {
                  selectedSize = activeSize;
                });
              }
            },
            child: Container(
              height: widget.radius * 2,
              width: widget.radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: !isActive ? null : Colours.lightThemePrimaryColour,
                border: Border.all(
                  color: context.isDarkMode
                      ? Colours.lightThemeTintStockColour
                      : Colours.lightThemeSecondaryTextColour,
                ),
              ),
              child: Center(
                child: Text(
                  size.toUpperCase(),
                  style: TextStyles.headingSemiBold.copyWith(
                    fontSize: 20,
                    color: isActive
                        ? Colours.lightThemeWhiteColour
                        : Colours.lightThemeSecondaryTextColour,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
