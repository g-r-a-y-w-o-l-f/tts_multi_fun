import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tts_flutter_online_azure/models/settings.dart';
import 'package:tts_flutter_online_azure/voice_loader/voice_loader.dart';
import 'package:tts_multi_fun/preferences/preferences_service.dart';
import 'package:tts_multi_fun/preferences/shared_preferences_service.dart';

import 'init_block_app.dart';

/*
void main() {
  runApp(const MyApp());
}
*/

void main() async {
  final talker = TalkerFlutter.init();
  GetIt.I.registerSingleton(talker);
  GetIt.I<Talker>().debug('Start Talker...');

  // _setupLocator(GetIt.I);

  final dio = Dio();
  dio.interceptors.add(TalkerDioLogger(
      talker: talker,
      settings: TalkerDioLoggerSettings(
          printRequestData: false
      )));

  Bloc.observer = TalkerBlocObserver(talker: talker);

  FlutterError.onError = (details) =>
      GetIt.I<Talker>().handle(details.exception, details.stack);

  // runZonedGuarded(() => {runApp(const TTSApp())},
  //         (ex, stack ) => {GetIt.I<Talker>().handle(ex, stack)});

  runZonedGuarded(() async { // async
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();
    runApp(
      FutureProvider<VoiceSetup?>(
        create: (context) async {
          final voiceLoader = VoiceLoader();
          return await voiceLoader.loadSettings();
        },
        initialData: null,
        child: const TTSApp(),
      ),
    );
  }, (ex, stack) => GetIt.I<Talker>().handle(ex, stack));

}

Future<void> _setupLocator(GetIt getIt) async {
  final sharedPreferencesService = SharedPreferencesService();
  await sharedPreferencesService.initialize();
  getIt.registerLazySingleton<PreferencesService>(() => sharedPreferencesService);
}
