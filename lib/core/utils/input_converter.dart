import 'package:dartz/dartz.dart';
import 'package:tdd_test_app/core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToInt(String str) {
    try {
      final convertedInt = int.parse(str);
      if (convertedInt.isNegative) {
        throw const FormatException();
      }

      return right(convertedInt);
    } catch (e) {
      return left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
