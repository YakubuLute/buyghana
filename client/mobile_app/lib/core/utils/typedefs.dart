import 'package:dartz/dartz.dart';
import 'package:buyghana/core/errors/failures.dart';

typedef DataMap = Map<String, dynamic>;
typedef ResultFuture<T> = Future<Either<Failure, T>>;
