import 'package:tdd_test_app/core/error/failure.dart';
import 'package:tdd_test_app/features/number_trivia/domain/entities/number_trivia_model.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepo {
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(
      int number);
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia();
}
