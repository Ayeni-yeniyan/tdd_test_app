import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tdd_test_app/core/usecases/usecase.dart';
import 'package:tdd_test_app/core/utils/input_converter.dart';
import 'package:tdd_test_app/features/number_trivia/domain/entities/number_trivia_model.dart';
import 'package:tdd_test_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_test_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class NumberTriviaController extends GetxController {
  @override
  void onInit() {
    getRandomNumberTrivia();
    super.onInit();
  }

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

  final inputController = TextEditingController();

  final _isBusy = false.obs;
  bool get isBusy => _isBusy.value;

  final _numberTriviaEntity = Rx<NumberTriviaEntity?>(null);
  NumberTriviaEntity? get numberTriviaEntity => _numberTriviaEntity.value;

  Future<void> getConcreteNumberTrivia() async {
    _isBusy.value = true;
    final inputResponse = _inputConverter.stringToInt(inputController.text);
    inputResponse.fold((failure) {
      // Get.rawSnackbar(title: failure.message);
    }, (convertedInt) async {
      final getConcreteRes =
          await _getConcreteNumberTrivia(ConcreteParams(convertedInt));
      getConcreteRes.fold((failure) {
        // Get.rawSnackbar(title: failure.message);
      }, (trivia) {
        _numberTriviaEntity.value = trivia;
      });
    });
    _isBusy.value = false;
  }

  Future<void> getRandomNumberTrivia() async {
    _isBusy.value = true;
    final getConcreteRes = await _getRandomNumberTrivia(const NoParams());
    getConcreteRes.fold((failure) {
      // Get.rawSnackbar(title: failure.message);
    }, (trivia) {
      _numberTriviaEntity.value = trivia;
    });
    _isBusy.value = false;
  }
}
