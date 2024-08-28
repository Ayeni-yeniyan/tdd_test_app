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

void main() {
  late NumberTriviaLocalDsImpl dataSource;
  late MockHive mockHive;
  late MockBox mockBox;
  setUp(() {
    mockHive = MockHive();
    mockBox = MockBox();
    when(() => mockHive.box('TDD_LOCAL_DB')).thenReturn(mockBox);
    dataSource = NumberTriviaLocalDsImpl(mockBox);
  });
  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixtureReader('trivia.json')));

    test(
        'should return NumberTrivia from Local storage when there is one in the cache',
        () async {
      // arrange
      final jsonMap =
          jsonDecode(fixtureReader('trivia.json')) as Map<String, dynamic>;
      when(() => mockBox.get(triviaKey)).thenReturn(jsonMap);
      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(() => mockBox.get(triviaKey));
      expect(result, equals(tNumberTriviaModel));
    });
    test(
        'should throw cache exception when there is no cached value in Local storage when there is one in the cache',
        () async {
      // arrange
      when(() => mockBox.get(triviaKey)).thenReturn(null);
      // act
      final call = dataSource.getLastNumberTrivia;
      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });
  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test');

    test('should call local Storage to cache the data', () async {
      // arrange
      // Future<void> jsonMap() async {}

      final jsonData = tNumberTriviaModel.toJson();
      when(() => mockBox.put(triviaKey, jsonData))
          .thenAnswer((_) async => Future.value());
      // act
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      verify(() => mockBox.put(triviaKey, jsonData));
      // expect(result, equals(tNumberTriviaModel));
    });
  });
}
