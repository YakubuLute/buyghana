import 'package:ecomly/core/extensions/colour_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ColourPalette extends StatefulWidget {
  const ColourPalette({
    required this.colours,
    required this.radius,
    this.onSelect,
    this.canScroll = false,
    this.spacing,
    this.padding,
    super.key,
  });

  final List<Color> colours;
  final ValueChanged<Color?>? onSelect;
  final double radius;
  final bool canScroll;
  final double? spacing;
  final EdgeInsetsGeometry? padding;

  @override
  State<ColourPalette> createState() => _ColourPaletteState();
}

class _ColourPaletteState extends State<ColourPalette> {
  Color? selectedColour;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        gradient: const LinearGradient(
          colors: [
            Color(0x50aa4b6b),
            Color(0x506b6b83),
            Color(0x503b8d99),
          ],
        ),
      ),
      child: SizedBox(
        height: widget.radius * 2,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(2),
          physics:
              widget.canScroll ? null : const NeverScrollableScrollPhysics(),
          itemCount: widget.colours.length,
          separatorBuilder: (_, __) => Gap(widget.spacing ?? 2),
          itemBuilder: (context, index) {
            final colour = widget.colours[index];
            final isActive = selectedColour == colour;
            final innerContainer = Container(
              height: widget.radius * 2,
              width: widget.radius * 2,
              decoration: BoxDecoration(
                color: colour,
                shape: BoxShape.circle,
              ),
            );
            return GestureDetector(
              onTap: () {
                Color? activeColour = colour;
                if (widget.onSelect != null) {
                  if (selectedColour == activeColour) {
                    activeColour = null;
                  }
                  widget.onSelect!(activeColour);
                  setState(() {
                    selectedColour = activeColour;
                  });
                }
              },
              child: isActive
                  ? Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: colour.inverse),
                      ),
                      child: innerContainer,
                    )
                  : innerContainer,
            );
          },
        ),
      ),
    );
  }
}
