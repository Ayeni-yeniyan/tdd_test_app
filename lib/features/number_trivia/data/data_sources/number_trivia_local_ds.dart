import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:tdd_test_app/core/error/exceptions.dart';
import 'package:tdd_test_app/features/number_trivia/data/models/number_trivia_model.dart';

abstract interface class NumberTriviaLocalDs {
  Future<NumberTriviaModel> getRandomNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia);
}

const String triviaKey = 'TRIVIA_KEY';

class NumberTriviaLocalDsImpl implements NumberTriviaLocalDs {
  final Box<dynamic> _hiveInterface;

  NumberTriviaLocalDsImpl(this._hiveInterface);

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia) async {
    final jsonString = numberTrivia.toJson();
    await _hiveInterface.add(jsonString);
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final limit = _hiveInterface.length;
    if (limit < 1) {
      throw CacheException();
    }
    try {
      final jsonString = _hiveInterface.getAt(getRandomNumber(limit));
      return NumberTriviaModel.fromJson((jsonString));
    } catch (e) {
      throw CacheException();
    }
  }

  int _getRandomNumber(int limit) => Random().nextInt(limit);

  @visibleForTesting
  int getRandomNumber(int limit) => _getRandomNumber(limit);
}
