import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_test_app/core/error/exceptions.dart';
import 'package:tdd_test_app/features/number_trivia/data/data_sources/number_trivia_local_ds.dart';
import 'package:tdd_test_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHive extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box {}

class MockNumberTriviaLocalDsImpl extends Mock
    implements NumberTriviaLocalDsImpl {}

void main() {
  late NumberTriviaLocalDsImpl dataSource;
  late MockHive mockHive;
  late MockBox mockBox;
  late MockNumberTriviaLocalDsImpl mockNumberTriviaLocalDsImpl;

  setUp(() {
    mockHive = MockHive();
    mockBox = MockBox();
    mockNumberTriviaLocalDsImpl = MockNumberTriviaLocalDsImpl();
    when(() => mockHive.box('TDD_LOCAL_DB')).thenReturn(mockBox);
    dataSource = NumberTriviaLocalDsImpl(mockBox);
  });
  group('getRandomNumberTrivia', () {
    final jsonMap =
        jsonDecode(fixtureReader('trivia.json')) as Map<String, dynamic>;
    final jsonMap1 =
        jsonDecode(fixtureReader('trivia_double.json')) as Map<String, dynamic>;
    final jsonMap2 =
        jsonDecode(fixtureReader('trivia1.json')) as Map<String, dynamic>;
    final jsonMap3 =
        jsonDecode(fixtureReader('trivia2.json')) as Map<String, dynamic>;
    final jsonList = [jsonMap, jsonMap1, jsonMap2];

    // get list length
    // Generate random index from list lenght
    // return number trivia at that index
    // Throw cache error when length is 0
    // Throw cache error when file is corrupted
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixtureReader('trivia.json')));
    final tNumberTriviaModel1 = NumberTriviaModel.fromJson(
        jsonDecode(fixtureReader('trivia_double.json')));
    final tNumberTriviaModel2 =
        NumberTriviaModel.fromJson(jsonDecode(fixtureReader('trivia1.json')));
    final triviaList = [
      tNumberTriviaModel,
      tNumberTriviaModel1,
      tNumberTriviaModel2,
    ];

    test(
        'should return random NumberTrivia from Local storage when there is one in the cache',
        () async {
      // arrange
      when(() => mockNumberTriviaLocalDsImpl.getRandomNumber(any()))
          .thenAnswer((_) => dataSource.getRandomNumber(jsonList.length));
      when(() => mockBox.length).thenReturn(jsonList.length);
      // act
      final randomNum =
          mockNumberTriviaLocalDsImpl.getRandomNumber(mockBox.length);

      when(() => mockBox.getAt(any())).thenReturn(jsonList[randomNum]);
      final result = await dataSource.getRandomNumberTrivia();
      // assert

      expect(result, equals(triviaList[randomNum]));

      verify(() => mockBox.length);
      verify(
          () => mockNumberTriviaLocalDsImpl.getRandomNumber(triviaList.length));
      verify(() => mockBox.getAt(any()));
    });
    test(
        'should throw cache exception when there is no cached value in Local storage when there is one in the cache',
        () async {
      // arrange
      when(() => mockBox.length).thenReturn(0);
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
      verify(() => mockBox.length);
      expect(0, mockBox.length);
    });
    test(
        'should throw cache exception when there is error serialising from Local storage when there is one in the cache',
        () async {
      // arrange
      when(() => mockBox.length).thenReturn(4);
      when(() => mockBox.getAt(any())).thenReturn(jsonMap3);

      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
      expect(4, mockBox.length);
      verify(() => mockBox.length);
    });
  });
  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test');

    test('should call local Storage to cache the data', () async {
      // arrange
      final jsonData = tNumberTriviaModel.toJson();
      when(() => mockBox.add(jsonData))
          .thenAnswer((_) async => Future<int>.value(0));
      // act
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      verify(() => mockBox.add(jsonData));
    });
  });
}
