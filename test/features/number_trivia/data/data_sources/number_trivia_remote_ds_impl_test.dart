import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_test_app/core/error/exceptions.dart';
import 'package:tdd_test_app/core/network/rest_client.dart';
import 'package:tdd_test_app/features/number_trivia/data/data_sources/numbertrivia_remote_ds.dart';
import 'package:tdd_test_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRestClient extends Mock implements RestClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockRestClient mockRestClient;
  late NumberTriviaRemoteDsImpl remoteDsImpl;
  late MockDio mockDio;
  void dioSetUp() {
    when(() => mockRestClient.dio).thenReturn(mockDio);
  }

  setUp(() {
    mockRestClient = MockRestClient();
    mockDio = MockDio();
    remoteDsImpl = NumberTriviaRemoteDsImpl(mockRestClient);
    dioSetUp();
  });

  final jsonMap =
      jsonDecode(fixtureReader('trivia.json')) as Map<String, dynamic>;
  final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonMap);
  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    test('should call numbersapi with the right url and content type of json',
        () async {
      // arrange
      when(
        () => mockDio.get('/$tNumber', options: any(named: 'options')),
      ).thenAnswer((_) async => Response(
          data: jsonMap, statusCode: 200, requestOptions: RequestOptions()));
      // act
      remoteDsImpl.getConcreteNumberTrivia(tNumber);
      // assert
      verify(() => mockDio.get('/$tNumber', options: any(named: 'options')));
    });
    test('should get number trivia for number from remote data', () async {
      // arrange
      when(
        () => mockDio.get('/$tNumber'),
      ).thenAnswer((_) async => Response(
          data: jsonMap, statusCode: 200, requestOptions: RequestOptions()));
      // act
      final response = await remoteDsImpl.getConcreteNumberTrivia(tNumber);
      // assert
      expect(response, equals(tNumberTriviaModel));
      verify(() => mockDio.get('/$tNumber'));
    });
    test('should throw a server exception on error', () async {
      // arrange
      when(
        () => mockDio.get('/$tNumber'),
      ).thenThrow(Exception());
      // act
      final call = remoteDsImpl.getConcreteNumberTrivia;
      // assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
      verify(() => mockDio.get('/$tNumber'));
    });
  });

  group('getRandomNumberTrivia', () {
    test('should call numbersapi with the right url and content type of json',
        () async {
      // arrange
      when(
        () => mockDio.get('/random', options: any(named: 'options')),
      ).thenAnswer((_) async => Response(
          data: jsonMap, statusCode: 200, requestOptions: RequestOptions()));
      // act
      remoteDsImpl.getRandomNumberTrivia();
      // assert
      verify(() => mockDio.get('/random', options: any(named: 'options')));
    });
    test('should get number trivia for number from remote data', () async {
      // arrange
      when(
        () => mockDio.get('/random'),
      ).thenAnswer((_) async => Response(
          data: jsonMap, statusCode: 200, requestOptions: RequestOptions()));
      // act
      final response = await remoteDsImpl.getRandomNumberTrivia();
      // assert
      expect(response, equals(tNumberTriviaModel));
      verify(() => mockDio.get('/random'));
    });

    test('should throw a server exception on error', () async {
      // arrange
      when(
        () => mockDio.get('/random'),
      ).thenThrow(Exception());
      // act
      final call = remoteDsImpl.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
      verify(() => mockDio.get('/random'));
    });
  });
}
/* 

 

 */