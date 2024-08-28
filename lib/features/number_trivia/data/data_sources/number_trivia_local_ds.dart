import 'package:tdd_test_app/features/number_trivia/data/models/number_trivia_model.dart';

abstract interface class NumberTriviaLocalDs {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia);
}
