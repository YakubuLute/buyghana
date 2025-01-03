// we will leave the categories and reviews in here regardless, because in
// this tutorial, I'm sure that the categories and reviews won't grow more
// than their current usecases, but in your case, if your categories and
// reviews become more complex, I would advice breaking up this cluster-fest
// into sub-modules like:

// Product Feature
//
// get_products
// get_product
// get_products_by_category
// get_new_arrivals
// get_popular
// search_all_products
// search_by_category
// search_by_category_and_gender_age_category

// Category Sub-Module
//
// get_categories
// get_category
// Review Sub-Module
//
// leave_review
// get_product_reviews

import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/product/domain/entities/category.dart';
import 'package:ecomly/src/product/domain/entities/product.dart';
import 'package:ecomly/src/product/domain/entities/review.dart';

abstract class ProductRepo {
  ResultFuture<List<Product>> getProducts(int page);

  ResultFuture<Product> getProduct(String productId);

  ResultFuture<List<Product>> getProductsByCategory({
    required String categoryId,
    required int page,
  });

  ResultFuture<List<Product>> getNewArrivals({
    required int page,
    String? categoryId,
  });

  ResultFuture<List<Product>> getPopular({
    required int page,
    String? categoryId,
  });

  ResultFuture<List<Product>> searchAllProducts({
    required String query,
    required int page,
  });

  ResultFuture<List<Product>> searchByCategory({
    required String query,
    required String categoryId,
    required int page,
  });

  ResultFuture<List<Product>> searchByCategoryAndGenderAgeCategory({
    required String query,
    required String categoryId,
    required String genderAgeCategory,
    required int page,
  });

  ResultFuture<List<ProductCategory>> getCategories();

  ResultFuture<ProductCategory> getCategory(String categoryId);

  ResultFuture<void> leaveReview({
    required String productId,
    required String userId,
    required String comment,
    required double rating,
  });

  ResultFuture<List<Review>> getProductReviews({
    required String productId,
    required int page,
  });
}
