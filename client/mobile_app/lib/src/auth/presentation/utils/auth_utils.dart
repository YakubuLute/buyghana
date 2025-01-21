import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthUtils {
  const AuthUtils();

  static void pickCountry(
    BuildContext context, {
    required ValueChanged<Country> onSelect,
  }) {
    showCountryPicker(
      context: context,
      onSelect: onSelect,
    );
  }
}
