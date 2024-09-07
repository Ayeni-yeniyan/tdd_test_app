import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdd_test_app/features/number_trivia/presentation/screens/number_trivia_screen.dart';

import 'injection_container.dart';

void main() async {
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NUMBER TRIVIA APPLICATION',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NumberTriviaScreen(),
    );
  }
}
