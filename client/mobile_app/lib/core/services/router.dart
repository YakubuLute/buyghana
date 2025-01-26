import 'package:buyghana/core/common/app/cache_helper.dart';
import 'package:buyghana/core/common/singletons/cache.dart';
import 'package:buyghana/core/services/injection_container.dart';
import 'package:buyghana/src/auth/presentation/views/forgot_password_screen.dart';
import 'package:buyghana/src/auth/presentation/views/login_screen.dart';
import 'package:buyghana/src/auth/presentation/views/register_screen.dart';
import 'package:buyghana/src/auth/presentation/views/reset_password_screen.dart';
import 'package:buyghana/src/auth/presentation/views/splash_screen.dart';
import 'package:buyghana/src/auth/presentation/views/verify_otp_screen.dart';
import 'package:buyghana/src/cart/presentation/views/cart_view.dart';
import 'package:buyghana/src/cart/presentation/views/checkout_successful_view.dart';
import 'package:buyghana/src/cart/presentation/views/checkout_view.dart';
import 'package:buyghana/src/dashboard/presentation/views/dashboard_screen.dart';
import 'package:buyghana/src/explore/presentation/views/explore_view.dart';
import 'package:buyghana/src/home/presentation/views/home_view.dart';
import 'package:buyghana/src/on_boarding/views/on_boarding_screen.dart';
import 'package:buyghana/src/order/presentation/views/order_details_view.dart';
import 'package:buyghana/src/order/presentation/views/orders_view.dart';
import 'package:buyghana/src/product/domain/entities/category.dart';
import 'package:buyghana/src/product/domain/entities/product.dart';
import 'package:buyghana/src/product/features/reviews/presentation/views/product_reviews.dart';
import 'package:buyghana/src/product/presentation/views/all_new_arrivals_view.dart';
import 'package:buyghana/src/product/presentation/views/all_popular_products_view.dart';
import 'package:buyghana/src/product/presentation/views/categorized_products_view.dart';
import 'package:buyghana/src/product/presentation/views/product_details_view.dart';
import 'package:buyghana/src/product/presentation/views/search_view.dart';
import 'package:buyghana/src/user/features/profile/presentation/views/profile_view.dart';
import 'package:buyghana/src/user/presentation/views/payment_profile_view.dart';
import 'package:buyghana/src/wishlist/presentation/views/wishlist_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

part 'router.main.dart';
