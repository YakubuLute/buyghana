import 'package:ecomly/core/common/widgets/input_field.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class VerticalLabelField extends StatelessWidget {
  const VerticalLabelField({
    super.key,
    required this.label,
    required this.controller,
    this.suffixIcon,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.defaultValidation = true,
    this.inputFormatters,
    this.prefix,
    this.enabled = true,
    this.mainFieldFlex = 1,
    this.prefixFlex = 1,
    this.readOnly = false,
    this.contentPadding,
    this.focusNode,
  });

  final String label;
  final Widget? suffixIcon;
  final String? hintText;
  final String? Function(String? value)? validator;
  final TextEditingController controller;

  final TextInputType? keyboardType;
  final bool obscureText;
  final bool defaultValidation;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final bool enabled;
  final bool readOnly;
  final int mainFieldFlex;
  final int prefixFlex;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.headingMedium4.adaptiveColour(context),
        ),
        const Gap(10),
        Row(
          children: [
            if (prefix != null) ...[
              Expanded(flex: prefixFlex, child: prefix!),
              const Gap(8),
            ],
            Expanded(
              flex: mainFieldFlex,
              child: InputField(
                controller: controller,
                focusNode: focusNode,
                suffixIcon: suffixIcon,
                hintText: hintText,
                validator: validator,
                keyboardType: keyboardType,
                obscureText: obscureText,
                defaultValidation: defaultValidation,
                inputFormatters: inputFormatters,
                enabled: enabled,
                readOnly: readOnly,
                contentPadding: contentPadding,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
