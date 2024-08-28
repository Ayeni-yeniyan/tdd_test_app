import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_test_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_test_app/features/number_trivia/domain/entities/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Model');
  test('should be a subclass of NumberTriviaEntity ', () async {
    // assert
    expect(tNumberTriviaModel, isA<NumberTriviaEntity>());
  });

  group('from json', () {
    test(
        'should return a valid model when the number from the json is an integer',
        () async {
      // arrange
      final Map<String, dynamic> fileJson =
          jsonDecode(fixtureReader('trivia.json'));
      // act
      final result = NumberTriviaModel.fromJson(fileJson);
      // assert
      expect(result, tNumberTriviaModel);
    });
    test(
        'should return a valid model when the number from the json is regarded as a double',
        () async {
      // arrange
      final Map<String, dynamic> fileJson =
          jsonDecode(fixtureReader('trivia_double.json'));
      // act
      final result = NumberTriviaModel.fromJson(fileJson);
      // assert
      expect(result, tNumberTriviaModel);
    });
  });
}
