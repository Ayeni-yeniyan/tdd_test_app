import 'package:dio/dio.dart';
import 'package:tdd_test_app/core/error/exceptions.dart';
import 'package:tdd_test_app/core/network/rest_client.dart';
import 'package:tdd_test_app/features/number_trivia/data/models/number_trivia_model.dart';

abstract interface class NumberTriviaRemoteDs {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDsImpl implements NumberTriviaRemoteDs {
  final RestClient _restClient;
  NumberTriviaRemoteDsImpl(this._restClient);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getNumberTriviaFromUrl('/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getNumberTriviaFromUrl('/random');

  Future<NumberTriviaModel> _getNumberTriviaFromUrl(String path) async {
    try {
      final response = await _restClient.dio.get(path);
      return NumberTriviaModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          message: e.response!.data ?? 'An error occured',
        );
      }
      throw ServerException(message: e.toString());
    }
  }
}
