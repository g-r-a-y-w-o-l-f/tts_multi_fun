// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    SelectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SelectionScreen(),
      );
    },
    TTSTypeOfflineRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TTSTypeOfflineScreen(),
      );
    },
    TTSTypeOnlineJayRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TTSTypeOnlineAzureScreen(),
      );
    },
    TTSTypeOnlineRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TTSTypeOnlineElevenScreen(),
      );
    },
  };
}

/// generated route for
/// [SelectionScreen]
class SelectionRoute extends PageRouteInfo<void> {
  const SelectionRoute({List<PageRouteInfo>? children})
      : super(
          SelectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TTSTypeOfflineScreen]
class TTSTypeOfflineRoute extends PageRouteInfo<void> {
  const TTSTypeOfflineRoute({List<PageRouteInfo>? children})
      : super(
          TTSTypeOfflineRoute.name,
          initialChildren: children,
        );

  static const String name = 'TTSTypeOfflineRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TTSTypeOnlineAzureScreen]
class TTSTypeOnlineJayRoute extends PageRouteInfo<void> {
  const TTSTypeOnlineJayRoute({List<PageRouteInfo>? children})
      : super(
          TTSTypeOnlineJayRoute.name,
          initialChildren: children,
        );

  static const String name = 'TTSTypeOnlineJayRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TTSTypeOnlineElevenScreen]
class TTSTypeOnlineRoute extends PageRouteInfo<void> {
  const TTSTypeOnlineRoute({List<PageRouteInfo>? children})
      : super(
          TTSTypeOnlineRoute.name,
          initialChildren: children,
        );

  static const String name = 'TTSTypeOnlineRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
