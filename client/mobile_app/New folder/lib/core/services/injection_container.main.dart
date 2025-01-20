part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _cacheInit();
  await _authInit();
  await _userInit();
  await _productInit();
  await _wishlistInit();
  await _cartInit();
  await _orderInit();
}

Future<void> _orderInit() async {
  sl
    ..registerLazySingleton(() => GetOrder(sl()))
    ..registerLazySingleton(() => GetUserOrders(sl()))
    ..registerLazySingleton<OrderRepo>(() => OrderRepoImpl(sl()))
    ..registerLazySingleton<OrderRemoteDataSrc>(
      () => OrderRemoteDataSrcImpl(sl()),
    );
}

Future<void> _cartInit() async {
  sl
    ..registerLazySingleton(() => AddToCart(sl()))
    ..registerLazySingleton(() => ChangeCartProductQuantity(sl()))
    ..registerLazySingleton(() => GetCart(sl()))
    ..registerLazySingleton(() => GetCartCount(sl()))
    ..registerLazySingleton(() => GetCartProduct(sl()))
    ..registerLazySingleton(() => RemoveFromCart(sl()))
    ..registerLazySingleton(() => InitiateCheckout(sl()))
    ..registerLazySingleton<CartRepo>(() => CartRepoImpl(sl()))
    ..registerLazySingleton<CartRemoteDataSrc>(
      () => CartRemoteDataSrcImpl(sl()),
    );
}

Future<void> _wishlistInit() async {
  sl
    ..registerLazySingleton(() => GetWishlist(sl()))
    ..registerLazySingleton(() => AddToWishlist(sl()))
    ..registerLazySingleton(() => RemoveFromWishlist(sl()))
    ..registerLazySingleton<WishlistRepo>(() => WishlistRepoImpl(sl()))
    ..registerLazySingleton<WishlistRemoteDataSrc>(
      () => WishlistRemoteDataSrcImpl(sl()),
    );
}

Future<void> _productInit() async {
  sl
    ..registerLazySingleton(() => GetCategories(sl()))
    ..registerLazySingleton(() => GetCategory(sl()))
    ..registerLazySingleton(() => GetNewArrivals(sl()))
    ..registerLazySingleton(() => GetPopular(sl()))
    ..registerLazySingleton(() => GetProduct(sl()))
    ..registerLazySingleton(() => GetProductReviews(sl()))
    ..registerLazySingleton(() => GetProducts(sl()))
    ..registerLazySingleton(() => GetProductsByCategory(sl()))
    ..registerLazySingleton(() => LeaveReview(sl()))
    ..registerLazySingleton(() => SearchAllProducts(sl()))
    ..registerLazySingleton(() => SearchByCategory(sl()))
    ..registerLazySingleton(() => SearchByCategoryAndGenderAgeCategory(sl()))
    ..registerLazySingleton<ProductRepo>(() => ProductRepoImpl(sl()))
    ..registerLazySingleton<ProductRemoteDataSrc>(
      () => ProductRemoteDataSrcImpl(sl()),
    );
}

Future<void> _userInit() async {
  sl
    ..registerLazySingleton(() => GetUser(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton(() => GetUserPaymentProfile(sl()))
    ..registerLazySingleton<UserRepo>(() => UserRepoImpl(sl()))
    ..registerLazySingleton<UserRemoteDataSrc>(
      () => UserRemoteDataSrcImpl(sl()),
    );
}

Future<void> _authInit() async {
  sl
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => Login(sl()))
    ..registerLazySingleton(() => Register(sl()))
    ..registerLazySingleton(() => ResetPassword(sl()))
    ..registerLazySingleton(() => VerifyOTP(sl()))
    ..registerLazySingleton(() => VerifyToken(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSrc>(
      () => AuthRemoteDataSrcImpl(sl()),
    )
    ..registerLazySingleton(http.Client.new);
}

Future<void> _cacheInit() async {
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton(() => CacheHelper(sl()))
    ..registerLazySingleton<SharedPreferences>(() => prefs);
}
