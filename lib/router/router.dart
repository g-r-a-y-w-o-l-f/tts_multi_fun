
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../screens/tts_type_offline_screen.dart';
import '../screens/tts_type_online_azure_screen.dart';
import '../screens/tts_type_online_eleven_screen.dart';
import '../screens/tts_type_selection_route.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SelectionRoute.page, initial: true),
    AutoRoute(page: TTSTypeOfflineRoute.page),
    AutoRoute(page: TTSTypeOnlineRoute.page),
    AutoRoute(page: TTSTypeOnlineJayRoute.page),
  ];
}