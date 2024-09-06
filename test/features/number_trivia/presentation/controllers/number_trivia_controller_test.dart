import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_test_app/core/utils/input_converter.dart';
import 'package:tdd_test_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_test_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import 'package:tdd_test_app/features/number_trivia/presentation/controllers/number_trivia_controller.dart';

class MockInputConverter extends Mock implements InputConverter {}

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

void main() {
  late MockInputConverter mockInputConverter;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late NumberTriviaController controller;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    controller = NumberTriviaController(
        inputConverter: mockInputConverter,
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia);
  });

  group('GetConcreteNumberTrivia', () {
    test('should ', () async {
      // arrange
      // act
      // assert
    });
  });
}
