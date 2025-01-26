abstract class Media {
  const Media();

  static const _baseImagePath = 'assets/images';
  static const _baseLottiePath = 'assets/lottie';

  static const onBoardingFemale = '$_baseImagePath/on_boarding_female.png';
  static const onBoardingMale = '$_baseImagePath/on_boarding_male.png';
  static const user = '$_baseImagePath/user.png';
  static const logo = '$_baseImagePath/logo.png';

  static const search = '$_baseLottiePath/search.json';
  static const searchLight = '$_baseLottiePath/search_light.json';
  static const searching = '$_baseLottiePath/searching.json';
  static const error = '$_baseLottiePath/error.json';
  static const emptyCart = '$_baseLottiePath/empty_cart.json';

  /// Animated check mark for checkout completion
  static const checkMark = '$_baseLottiePath/check.json';
}
