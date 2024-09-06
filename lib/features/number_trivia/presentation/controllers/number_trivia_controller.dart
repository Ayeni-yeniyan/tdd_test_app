// import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tdd_test_app/core/utils/input_converter.dart';
import 'package:tdd_test_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_test_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class NumberTriviaController extends GetxController {
  final InputConverter _inputConverter;
  final GetConcreteNumberTrivia _getConcreteNumberTrivia;
  final GetRandomNumberTrivia _getRandomNumberTrivia;
  NumberTriviaController({
    required InputConverter inputConverter,
    required GetConcreteNumberTrivia getConcreteNumberTrivia,
    required GetRandomNumberTrivia getRandomNumberTrivia,
  })  : _inputConverter = inputConverter,
        _getConcreteNumberTrivia = getConcreteNumberTrivia,
        _getRandomNumberTrivia = getRandomNumberTrivia;

  // final inputController = TextEditingController();

  getConcreteNumberTrivia() {
    _inputConverter.stringToInt('1');
  }
}
