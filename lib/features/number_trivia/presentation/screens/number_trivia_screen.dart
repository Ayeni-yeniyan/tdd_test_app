import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdd_test_app/features/number_trivia/presentation/controllers/number_trivia_controller.dart';

class NumberTriviaScreen extends StatelessWidget {
  const NumberTriviaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Number trivia Feature',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const Column(
        children: [NumberTriviaDisplayTile()],
      ),
    );
  }
}

class NumberTriviaDisplayTile extends StatelessWidget {
  const NumberTriviaDisplayTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NumberTriviaController>(builder: (controller) {
      return Column(
        children: [
          Text(
            controller.numberTriviaEntity?.text ?? 'Search for a trivia!',
          ),
        ],
      );
    });
  }
}
