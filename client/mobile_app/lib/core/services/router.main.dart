part of 'router.dart';

/// For routes that should NOT have the bottom nav bar
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// For routes that SHOULD have the bottom nav bar
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        redirect: (context, state) {
          /// First we check if session exists and user exists, if either is
          /// missing, we check if they're first timers, because their session
          /// could be gone but they aren't first timers, so, we take them to
          /// login, but if they are first timers, we return null which pushes us
          /// to the builder
          final cacheHelper = sl<CacheHelper>()
            ..getSessionToken()
            ..getUserId();
          if ((Cache.instance.sessionToken == null ||
                  Cache.instance.userId == null) &&
              !cacheHelper.isFirstTime()) {
            return LoginScreen.path;
          }
          if (state.extra == 'home') return HomeView.path;
          return null;
        },
        builder: (context, state) {
          /// Now that we're here, we check again if the user is first timer,
          /// so, if they were first timer from that push in the redirect,
          /// then we catch it here and take em to onboarding, else, we go
          /// ahead and check if when we pushed to '/', we added the <home>
          /// extra, if we did, then we were trying to go home, else, we just
          /// go to the splashscreen, where the OTP gets verified, if it's
          /// still valid, we go home, else, we go back to login.
          final cacheHelper = sl<CacheHelper>()
            ..getSessionToken()
            ..getUserId();
          if (cacheHelper.isFirstTime()) {
            return const OnBoardingScreen();
          }

          return const SplashScreen();
        }),
    GoRoute(
      path: LoginScreen.path,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RegisterScreen.path,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: ForgotPasswordScreen.path,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: VerifyOTPScreen.path,
      builder: (context, state) => VerifyOTPScreen(
        email: state.extra as String,
      ),
    ),
    GoRoute(
      path: ResetPasswordScreen.path,
      builder: (context, state) => ResetPasswordScreen(
        email: state.extra as String,
      ),
    ),
    GoRoute(
      path: SearchView.path,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, __) => const SearchView(),
    ),
    GoRoute(
      path: '/products/:productId',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) => ProductDetailsView(
        state.pathParameters['productId'] as String,
      ),
    ),
    GoRoute(
      path: '/products/:productId/reviews',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) {
        return ProductReviews(state.extra as Product);
      },
    ),
    GoRoute(
      path: '/users/:userId/orders',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) {
        return OrdersView(userId: state.pathParameters['userId'] as String);
      },
    ),
    GoRoute(
      path: '/orders/:orderId',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) {
        return OrderDetailsView(
          orderId: state.pathParameters['orderId'] as String,
        );
      },
    ),
    GoRoute(
        path: PaymentProfileView.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) {
          return PaymentProfileView(sessionUrl: state.extra as String);
        }),
    GoRoute(
      path: CheckoutView.path,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) {
        return CheckoutView(sessionUrl: state.extra as String);
      },
    ),
    GoRoute(
      path: CheckoutSuccessfulView.path,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) {
        return const CheckoutSuccessfulView();
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return DashboardScreen(state: state, child: child);
      },
      routes: [
        GoRoute(
          path: HomeView.path,
          // OBVIOUSLY, but making a point
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const HomeView(),
          routes: [
            GoRoute(
              path: AllNewArrivalsView.path,
              builder: (context, state) => const AllNewArrivalsView(),
            ),
            GoRoute(
              path: AllPopularProductsView.path,
              builder: (context, state) => const AllPopularProductsView(),
            ),
          ],
        ),
        GoRoute(
          path: ExploreView.path,
          builder: (context, state) => const ExploreView(),
        ),
        GoRoute(
          path: WishlistView.path,
          builder: (context, state) => const WishlistView(),
        ),
      ],
    ),
    GoRoute(
      path: ProfileView.path,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ProfileView(),
    ),
    GoRoute(
      path: CartView.path,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const CartView(),
    ),
    GoRoute(
      path: '/:category_name',
      redirect: (_, state) {
        if (state.extra is! ProductCategory) return '/home';
        return null;
      },
      builder: (_, state) {
        return CategorizedProductsView(state.extra as ProductCategory);
      },
    ),
  ],
);
