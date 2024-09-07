import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tdd_test_app/core/network/rest_client.dart';
import 'features/number_trivia/data/data_sources/number_trivia_local_ds.dart';
import 'features/number_trivia/data/repositories/number_trivai_repo_impl.dart';
import 'core/network/network_info.dart';
import 'core/utils/input_converter.dart';
import 'features/number_trivia/data/data_sources/numbertrivia_remote_ds.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/controllers/number_trivia_controller.dart';

import 'features/number_trivia/domain/repositories/number_trivia_repo.dart';

Future<void> initializeDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final numberTriviaBox = await Hive.openBox('NUMBER_TRIVIA_BOX');
  Get.lazyPut(() => RestClient());
  Get.lazyPut(() => RestClient());
  Get.lazyPut<NumberTriviaLocalDs>(
      () => NumberTriviaLocalDsImpl(numberTriviaBox));
  Get.lazyPut<NumberTriviaRemoteDs>(() => NumberTriviaRemoteDsImpl(Get.find()));
  Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(InternetConnectionChecker()));
  Get.lazyPut<NumberTriviaRepo>(() => NumbeTriviaRepoImpl(
        localDataSource: Get.find(),
        remoteDataSource: Get.find(),
        networkInfo: Get.find(),
      ));
  Get.lazyPut(() => GetConcreteNumberTrivia(Get.find()));
  Get.lazyPut(() => GetRandomNumberTrivia(Get.find()));
  Get.lazyPut(() => InputConverter());
  Get.lazyPut(() => NumberTriviaController(
        getConcreteNumberTrivia: Get.find(),
        getRandomNumberTrivia: Get.find(),
        inputConverter: Get.find(),
      ));
}
