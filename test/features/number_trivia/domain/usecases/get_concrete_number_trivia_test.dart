import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_test_app/features/number_trivia/domain/entities/number_trivia_model.dart';
import 'package:tdd_test_app/features/number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:tdd_test_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepo extends Mock implements NumberTriviaRepo {}

void main() {
  late MockNumberTriviaRepo mockNumberTriviaRepository;
  late GetConcreteNumberTrivia usecase;
  group('getConcreteNumberTrivia -', () {
    setUp(() {
      mockNumberTriviaRepository = MockNumberTriviaRepo();
      usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
    });
    const tNumber = 1;
    const tNumberTrivia = NumberTriviaEntity(number: 1, text: 'test entity');
    test('should get trivia for the number from the repository', () async {
      // arrange
      when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      final result = await usecase(const ConcreteParams(tNumber));
      // assert
      expect(result, const Right(tNumberTrivia));
      verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    });
  });
}
  // test('should ', () async {
  //     // arrange
      
  //     // act
      
  //     // assert
      
  //   });