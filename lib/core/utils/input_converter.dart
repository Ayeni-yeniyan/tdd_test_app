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
      return left(const InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure()
      : super('Invalid input. Input must be an integer greater than 0');
  @override
  List<Object?> get props => [];
}
