import 'package:tdd_test_app/features/number_trivia/data/models/number_trivia_model.dart';

abstract interface class NumberTriviaRemoteDs {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}
