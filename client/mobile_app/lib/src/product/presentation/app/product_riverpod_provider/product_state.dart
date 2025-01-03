part of 'product_provider.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class FetchingProducts extends ProductState {
  const FetchingProducts();
}

class Searching extends ProductState {
  const Searching();
}

class FetchingReviews extends ProductState {
  const FetchingReviews();
}

class FetchingCategories extends ProductState {
  const FetchingCategories();
}

class FetchingCategory extends ProductState {
  const FetchingCategory();
}

class FetchingProduct extends ProductState {
  const FetchingProduct();
}

class Reviewing extends ProductState {
  const Reviewing();
}

class ProductsFetched extends ProductState {
  const ProductsFetched(this.products);

  final List<Product> products;

  @override
  List<Object> get props => products;
}

class CategoriesFetched extends ProductState {
  const CategoriesFetched(this.categories);

  final List<ProductCategory> categories;

  @override
  List<Object> get props => categories;
}

class ReviewsFetched extends ProductState {
  const ReviewsFetched(this.reviews);

  final List<Review> reviews;

  @override
  List<Object> get props => reviews;
}

class CategoryFetched extends ProductState {
  const CategoryFetched(this.category);

  final ProductCategory category;

  @override
  List<Object> get props => [category];
}

class ProductFetched extends ProductState {
  const ProductFetched(this.product);

  final Product product;

  @override
  List<Object> get props => [product];
}

class ProductReviewed extends ProductState {
  const ProductReviewed();
}

class ProductError extends ProductState {
  const ProductError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
