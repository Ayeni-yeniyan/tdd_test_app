import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_test_app/core/error/failure.dart';
import 'package:tdd_test_app/core/usecases/usecase.dart';
import 'package:tdd_test_app/features/number_trivia/domain/entities/number_trivia_model.dart';
import 'package:tdd_test_app/features/number_trivia/domain/repositories/number_trivia_repo.dart';

class GetConcreteNumberTrivia
    implements Usecase<NumberTriviaEntity, ConcreteParams> {
  final NumberTriviaRepo _numberTriviaRepo;
  GetConcreteNumberTrivia(this._numberTriviaRepo);

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(
      ConcreteParams params) async {
    return await _numberTriviaRepo.getConcreteNumberTrivia(params.number);
  }
}

class ConcreteParams extends Equatable {
  final int number;
  const ConcreteParams(this.number);

  @override
  List<Object?> get props => [number];
}
