import 'package:dartz/dartz.dart';
import 'package:tdd_test_app/core/error/exceptions.dart';
import 'package:tdd_test_app/core/error/failure.dart';
import 'package:tdd_test_app/core/network/network_info.dart';
import 'package:tdd_test_app/features/number_trivia/data/data_sources/number_trivia_local_ds.dart';
import 'package:tdd_test_app/features/number_trivia/data/data_sources/numbertrivia_remote_ds.dart';
import 'package:tdd_test_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_test_app/features/number_trivia/domain/entities/number_trivia_model.dart';
import 'package:tdd_test_app/features/number_trivia/domain/repositories/number_trivia_repo.dart';

typedef Future<NumberTriviaModel> _ConcreteRandomChooser();

class NumbeTriviaRepoImpl implements NumberTriviaRepo {
  final NumberTriviaLocalDs _localDataSource;
  final NumberTriviaRemoteDs _remoteDataSource;
  final NetworkInfo _networkInfo;

  NumbeTriviaRepoImpl(
      {required NumberTriviaLocalDs localDataSource,
      required NumberTriviaRemoteDs remoteDataSource,
      required NetworkInfo networkInfo})
      : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;
  @override
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(
      int number) async {
    return _callTriviaFuntion(
        () => _remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia() async {
    return _callTriviaFuntion(() => _remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTriviaEntity>> _callTriviaFuntion(
      _ConcreteRandomChooser getConcreteOrRandomTrivia) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await getConcreteOrRandomTrivia();
        _localDataSource.cacheNumberTrivia(response);
        return right(response);
      } on ServerException catch (e) {
        return left(ServerFailure(e.message));
      }
    }
    try {
      final response = await _localDataSource.getLastNumberTrivia();
      return right(response);
    } on CacheException {
      return left(const CacheFailure());
    }
  }
}
