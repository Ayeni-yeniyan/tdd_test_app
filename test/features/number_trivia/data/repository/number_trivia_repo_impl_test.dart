import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_test_app/core/error/exceptions.dart';
import 'package:tdd_test_app/core/error/failure.dart';
import 'package:tdd_test_app/core/network/network_info.dart';
import 'package:tdd_test_app/features/number_trivia/data/data_sources/number_trivia_local_ds.dart';
import 'package:tdd_test_app/features/number_trivia/data/data_sources/numbertrivia_remote_ds.dart';
import 'package:tdd_test_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_test_app/features/number_trivia/data/repositories/number_trivai_repo_impl.dart';
import 'package:tdd_test_app/features/number_trivia/domain/entities/number_trivia_model.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDs {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDs {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late NumbeTriviaRepoImpl repository;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = NumbeTriviaRepoImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tNumber = 1;
  const tNumberTriviaModel =
      NumberTriviaModel(number: tNumber, text: 'test entity');
  const NumberTriviaEntity tNumberTrivia = tNumberTriviaModel;
  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    test('should check if device is online', () async {
      // arrange
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async {});

      when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async {});

        // act
        final response = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(response, equals(const Right(tNumberTrivia)));
      });
      test(
          'should cache the data locally when the call remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async {});

        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      });
      test(
          'should return server failure when the call remote data source is unsuccessful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException(message: 'Test error'));
        // act
        final response = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockLocalDataSource);
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(response, equals(const Left(ServerFailure('Test error'))));
      });
    });

    runTestOffline(() {
      test('should retrieve locally cached data when cache is present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final response = await repository.getConcreteNumberTrivia(tNumber);
        // assert

        verify(() => mockLocalDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(response, equals(const Right(tNumberTrivia)));
      });
      test(
          'should return cacheexception when there is no locally cached data present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getRandomNumberTrivia())
            .thenThrow(CacheException('test'));
        // act
        final response = await repository.getConcreteNumberTrivia(tNumber);
        // assert

        verify(() => mockLocalDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(response, equals(const Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    test('should check if device is online', () async {
      // arrange
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async {});
      when(() => mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.getRandomNumberTrivia();
      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async {});

        // act
        final response = await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        expect(response, equals(const Right(tNumberTrivia)));
      });
      test(
          'should cache the data locally when the call remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async {});

        // act
        await repository.getRandomNumberTrivia();
        // assert
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
      });
      test(
          'should return server failure when the call remote data source is unsuccessful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException(message: 'Test error'));
        // act
        final response = await repository.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockLocalDataSource);
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        expect(response, equals(const Left(ServerFailure('Test error'))));
      });
    });

    runTestOffline(() {
      test('should retrieve locally cached data when cache is present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final response = await repository.getRandomNumberTrivia();
        // assert

        verify(() => mockLocalDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(response, equals(const Right(tNumberTrivia)));
      });
      test(
          'should return cacheexception when there is no locally cached data present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getRandomNumberTrivia())
            .thenThrow(CacheException('test'));
        // act
        final response = await repository.getRandomNumberTrivia();
        // assert

        verify(() => mockLocalDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(response, equals(const Left(CacheFailure())));
      });
    });
  });
}
