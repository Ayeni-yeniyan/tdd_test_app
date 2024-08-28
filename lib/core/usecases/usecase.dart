import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_test_app/core/error/failure.dart';

abstract interface class Usecase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}
