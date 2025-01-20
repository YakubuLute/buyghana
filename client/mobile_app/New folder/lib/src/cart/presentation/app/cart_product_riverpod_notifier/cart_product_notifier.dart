import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_product_notifier.g.dart';

@riverpod
class CartProductNotifier extends _$CartProductNotifier {
  @override
  List<String> build() {
    return [];
  }

  void selectProduct(String cartProductId) {
    if (!state.contains(cartProductId)) {
      state = [...state, cartProductId];
    }
  }

  void deselectProduct(String cartProductId) {
    state = state.where((id) => id != cartProductId).toList();
  }

  void selectAll(Iterable<String> cartProducts) {
    state.addAll(cartProducts);
    state = state.toSet().toList();
  }

  void deselectAll() {
    state = [];
  }
}
