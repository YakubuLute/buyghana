import 'package:ecomly/core/usecase/usecase.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/order/domain/entities/order.dart';
import 'package:ecomly/src/order/domain/repos/order_repo.dart';

class GetOrder extends UsecaseWithParams<Order, String> {
  const GetOrder(this._repo);

  final OrderRepo _repo;

  @override
  ResultFuture<Order> call(String params) => _repo.getOrder(params);
}
