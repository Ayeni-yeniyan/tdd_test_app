import 'package:hive/hive.dart';
import 'package:tdd_test_app/core/error/exceptions.dart';
import 'package:tdd_test_app/features/number_trivia/data/models/number_trivia_model.dart';

abstract interface class NumberTriviaLocalDs {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia);
}

const String triviaKey = 'TRIVIA_KEY';

class NumberTriviaLocalDsImpl implements NumberTriviaLocalDs {
  final Box<dynamic> _hiveInterface;

  NumberTriviaLocalDsImpl(this._hiveInterface);

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia) async {
    final jsonString = numberTrivia.toJson();
    await _hiveInterface.put(triviaKey, jsonString);
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString = _hiveInterface.get(triviaKey);
    if (jsonString != null) {
      return NumberTriviaModel.fromJson((jsonString));
    } else {
      throw CacheException();
    }
  }
}
