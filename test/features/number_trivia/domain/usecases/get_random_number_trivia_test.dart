import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_test_app/core/usecases/usecase.dart';
import 'package:tdd_test_app/features/number_trivia/domain/entities/number_trivia_model.dart';
import 'package:tdd_test_app/features/number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:tdd_test_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepo extends Mock implements NumberTriviaRepo {}

// class MockGetConcreteNumberTrivia extends Mock
//     implements GetConcreteNumberTrivia {}

void main() {
  late MockNumberTriviaRepo mockNumberTriviaRepository;
  late GetRanddomNumberTrivia usecase;
  group('getConcreteNumberTrivia -', () {
    setUp(() {
      mockNumberTriviaRepository = MockNumberTriviaRepo();
      usecase = GetRanddomNumberTrivia(mockNumberTriviaRepository);
    });
    const tNumberTrivia = NumberTriviaEntity(number: 1, text: 'test entity');
    test('should get trivia from the repository', () async {
      // arrange
      when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      final result = await usecase(const NoParams());
      // assert
      expect(result, const Right(tNumberTrivia));
      verify(() => mockNumberTriviaRepository.getRandomNumberTrivia())
          .called(1);
    });
  });
}
