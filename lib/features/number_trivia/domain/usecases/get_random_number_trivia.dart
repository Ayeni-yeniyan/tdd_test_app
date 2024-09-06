import 'package:dartz/dartz.dart';
import 'package:tdd_test_app/core/error/failure.dart';
import 'package:tdd_test_app/core/usecases/usecase.dart';
import 'package:tdd_test_app/features/number_trivia/domain/entities/number_trivia_model.dart';
import 'package:tdd_test_app/features/number_trivia/domain/repositories/number_trivia_repo.dart';

class GetRandomNumberTrivia implements Usecase<NumberTriviaEntity, NoParams> {
  final NumberTriviaRepo _numberTriviaRepo;
  GetRandomNumberTrivia(this._numberTriviaRepo);

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(NoParams params) async {
    return await _numberTriviaRepo.getRandomNumberTrivia();
  }
}
