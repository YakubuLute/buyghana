extension IntExt on int {
  String get pluralizeReviews {
    if (this > 1 || this == 0) return '$this Reviews';
    return '$this Review';
  }

  String pluralizeWith(String singularWord, {String? pluralForm}) {
    var pluralFormOfWord = pluralForm ?? '${singularWord}s';
    if (this > 1 || this == 0) return '$this $pluralFormOfWord';
    return '$this $singularWord';
  }

  String get pumpNumber {
    if (toString().length == 1) return '0$this';
    return toString();
  }
}
