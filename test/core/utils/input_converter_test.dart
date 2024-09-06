import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_test_app/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
    // controller = NumberTriviaController(inputConverter: mockInputConverter);
  });
  group('stringToInt', () {
    test(
        'should convert string to valid integer when the string represents an unsigned integer',
        () async {
      // arrange
      const str = '123';
      // act
      final result = inputConverter.stringToInt(str);
      // assert
      expect(result, right(123));
    });
    test(
        'should throw failure when inputed string does not represents a valid integer',
        () async {
      // arrange
      const str = '1oo23';
      // act
      final result = inputConverter.stringToInt(str);
      // assert
      expect(result, left(InvalidInputFailure()));
    });
    test('should throw failure when inputed string is a negative integer',
        () async {
      // arrange
      const str = '-123 ';
      // act
      final result = inputConverter.stringToInt(str);
      // assert
      expect(result, left(InvalidInputFailure()));
    });
  });
}
