import 'package:tdd_test_app/features/number_trivia/domain/entities/number_trivia_model.dart';

class NumberTriviaModel extends NumberTriviaEntity {
  const NumberTriviaModel({
    required super.number,
    required super.text,
  });

  factory NumberTriviaModel.fromJson(Map<String, dynamic> map) {
    return NumberTriviaModel(
      number: (map['number'] as num).toInt(),
      text: map['text'] as String,
    );
  }
}
