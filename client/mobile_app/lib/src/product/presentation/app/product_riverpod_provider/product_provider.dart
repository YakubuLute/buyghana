import 'package:ecomly/core/services/injection_container.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/domain/entities/review.dart';
import 'package:ecomly/src/product/domain/usecases/get_categories.dart';
import 'package:ecomly/src/product/domain/usecases/get_category.dart';
import 'package:ecomly/src/product/domain/usecases/get_new_arrivals.dart';
import 'package:ecomly/src/product/domain/usecases/get_popular.dart';
import 'package:ecomly/src/product/domain/usecases/get_product.dart';
import 'package:ecomly/src/product/domain/usecases/get_product_reviews.dart';
import 'package:ecomly/src/product/domain/usecases/get_products.dart';
import 'package:ecomly/src/product/domain/usecases/get_products_by_category.dart';
import 'package:ecomly/src/product/domain/usecases/leave_review.dart';
import 'package:ecomly/src/product/domain/usecases/search_all_products.dart';
import 'package:ecomly/src/product/domain/usecases/search_by_category.dart';
import 'package:ecomly/src/product/domain/usecases/search_by_category_and_gender_age_category.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_provider.g.dart';
part 'product_state.dart';

@riverpod
class ProductAdapter extends _$ProductAdapter {
  @override
  ProductState build([GlobalKey? familyKey]) {
    _getCategories = sl<GetCategories>();
    _getCategory = sl<GetCategory>();
    _getNewArrivals = sl<GetNewArrivals>();
    _getPopular = sl<GetPopular>();
    _getProduct = sl<GetProduct>();
    _getProductReviews = sl<GetProductReviews>();
    _getProducts = sl<GetProducts>();
    _getProductsByCategory = sl<GetProductsByCategory>();
    _leaveReview = sl<LeaveReview>();
    _searchAllProducts = sl<SearchAllProducts>();
    _searchByCategory = sl<SearchByCategory>();
    _searchByCategoryAndGenderAgeCategory =
        sl<SearchByCategoryAndGenderAgeCategory>();
    return const ProductInitial();
  }

  late GetCategories _getCategories;
  late GetCategory _getCategory;
  late GetNewArrivals _getNewArrivals;
  late GetPopular _getPopular;
  late GetProduct _getProduct;
  late GetProductReviews _getProductReviews;
  late GetProducts _getProducts;
  late GetProductsByCategory _getProductsByCategory;
  late LeaveReview _leaveReview;
  late SearchAllProducts _searchAllProducts;
  late SearchByCategory _searchByCategory;
  late SearchByCategoryAndGenderAgeCategory
      _searchByCategoryAndGenderAgeCategory;

  Future<void> getCategories() async {
    state = const FetchingCategories();
    final result = await _getCategories();
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (categories) => state = CategoriesFetched(categories),
    );
  }

  Future<void> getCategory(String categoryId) async {
    state = const FetchingCategory();
    final result = await _getCategory(categoryId);
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (category) => state = CategoryFetched(category),
    );
  }

  Future<void> getNewArrivals({required int page, String? categoryId}) async {
    state = const FetchingProducts();
    final result = await _getNewArrivals(GetNewArrivalsParams(
      page: page,
      categoryId: categoryId,
    ));
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }

  Future<void> getPopular({required int page, String? categoryId}) async {
    state = const FetchingProducts();
    final result = await _getPopular(GetPopularParams(
      page: page,
      categoryId: categoryId,
    ));
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }

  Future<void> getProduct(String productId) async {
    state = const FetchingProduct();
    final result = await _getProduct(productId);
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (product) => state = ProductFetched(product),
    );
  }

  Future<void> getProductReviews({
    required String productId,
    required int page,
  }) async {
    state = const FetchingReviews();
    final result = await _getProductReviews(
      GetProductReviewsParams(productId: productId, page: page),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (reviews) {
        if (page == 1) {
          debugPrint('ADAPTER SAYS ${reviews.length} REVIEWS');
        }
        state = ReviewsFetched(reviews);
      },
    );
  }

  Future<void> getProducts(int page) async {
    state = const FetchingProducts();
    final result = await _getProducts(page);
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }

  Future<void> getProductsByCategory({
    required String categoryId,
    required int page,
  }) async {
    state = const FetchingProducts();
    final result = await _getProductsByCategory(
      GetProductsByCategoryParams(categoryId: categoryId, page: page),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }

  Future<void> leaveReview({
    required String productId,
    required String userId,
    required String comment,
    required double rating,
  }) async {
    state = const Reviewing();
    final result = await _leaveReview(
      LeaveReviewParams(
        productId: productId,
        userId: userId,
        comment: comment,
        rating: rating,
      ),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (_) => state = const ProductReviewed(),
    );
  }

  Future<void> searchAllProducts({
    required String query,
    required int page,
  }) async {
    state = const Searching();
    final result = await _searchAllProducts(
      SearchAllProductsParams(query: query, page: page),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }

  Future<void> searchByCategory({
    required String query,
    required String categoryId,
    required int page,
  }) async {
    state = const Searching();
    final result = await _searchByCategory(
      SearchByCategoryParams(query: query, categoryId: categoryId, page: page),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }

  Future<void> searchByCategoryAndGenderAgeCategory({
    required String query,
    required String categoryId,
    required String genderAgeCategory,
    required int page,
  }) async {
    state = const Searching();
    final result = await _searchByCategoryAndGenderAgeCategory(
      SearchByCategoryAndGenderAgeCategoryParams(
          query: query,
          categoryId: categoryId,
          genderAgeCategory: genderAgeCategory,
          page: page),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }
}
