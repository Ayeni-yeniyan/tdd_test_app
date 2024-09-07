import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_test_app/core/error/failure.dart';
import 'package:tdd_test_app/core/usecases/usecase.dart';
import 'package:tdd_test_app/core/utils/input_converter.dart';
import 'package:tdd_test_app/features/number_trivia/data/models/number_trivia_model.dart';
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
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
    );
  });

  group('GetConcreteNumberTrivia', () {
    const tNumberTrivia = NumberTriviaModel(number: 1, text: 'test trivia');
    const tNumberParsed = 1;
    const tNumber = '1';
    const tNumberError = '1dd';
    void concreteSuccessSetup() {
      when(() => mockInputConverter.stringToInt(any()))
          .thenReturn(right(tNumberParsed));
      when(
        () => mockGetConcreteNumberTrivia(const ConcreteParams(tNumberParsed)),
      ).thenAnswer((_) async => right(tNumberTrivia));
    }

    test(
        'should call the inputconverter to validate and convert the string from the TextEditingController to an integer',
        () async {
      // arrange
      concreteSuccessSetup();
      // act
      controller.inputController.text = tNumber;
      await controller.getConcreteNumberTrivia();
      // assert
      verify(
        () => mockInputConverter.stringToInt(controller.inputController.text),
      );
    });
    test('should return error state when the input converter throws an error',
        () async {
      // arrange
      when(() => mockInputConverter.stringToInt(any()))
          .thenReturn(left(const InvalidInputFailure()));
      // act
      controller.inputController.text = tNumberError;
      await controller.getConcreteNumberTrivia();
      // assert
      verify(
        () => mockInputConverter.stringToInt(any()),
      );
      verifyZeroInteractions(mockGetConcreteNumberTrivia);
    });
    test('should show catch error message on server exception', () async {
      // arrange

      when(() => mockInputConverter.stringToInt(any()))
          .thenReturn(right(tNumberParsed));
      when(() =>
              mockGetConcreteNumberTrivia(const ConcreteParams(tNumberParsed)))
          .thenAnswer((_) async => left(ServerFailure()));
      // act
      await controller.getConcreteNumberTrivia();
      // assert
      verify(
        () => mockGetConcreteNumberTrivia(const ConcreteParams(tNumberParsed)),
      );
    });
    test(
        'should call the GetConcreteNumberTrivia usecase update number trivia ',
        () async {
      // arrange
      concreteSuccessSetup();
      // act

      controller.inputController.text = tNumber;
      await controller.getConcreteNumberTrivia();
      // assert
      verify(
        () => mockInputConverter.stringToInt(controller.inputController.text),
      );
      verify(
        () => mockGetConcreteNumberTrivia(const ConcreteParams(tNumberParsed)),
      );
      expect(controller.numberTriviaEntity, equals(tNumberTrivia));
    });
  });
  group('GetRandomNumberTrivia', () {
    const tNumberTrivia = NumberTriviaModel(number: 1, text: 'test trivia');
    void randomSuccessSetup() {
      when(
        () => mockGetRandomNumberTrivia(const NoParams()),
      ).thenAnswer((_) async => right(tNumberTrivia));
    }

    test('should show catch error message on server exception', () async {
      // arrange
      when(() => mockGetRandomNumberTrivia(const NoParams()))
          .thenAnswer((_) async => left(ServerFailure()));
      // act
      await controller.getRandomNumberTrivia();
      // assert
      verify(() => mockGetRandomNumberTrivia(const NoParams()));
    });
    test('should call the GetRandomNumberTrivia usecase update number trivia ',
        () async {
      // arrange
      randomSuccessSetup();
      // act
      await controller.getRandomNumberTrivia();
      // assert

      verify(
        () => mockGetRandomNumberTrivia(const NoParams()),
      );
      expect(controller.numberTriviaEntity, equals(tNumberTrivia));
    });
  });
}
