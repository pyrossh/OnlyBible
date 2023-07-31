// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $selectScreenRoute,
    ];

RouteBase get $selectScreenRoute => GoRouteData.$route(
      path: '/select',
      factory: $SelectScreenRouteExtension._fromState,
    );

extension $SelectScreenRouteExtension on SelectScreenRoute {
  static SelectScreenRoute _fromState(GoRouterState state) =>
      SelectScreenRoute();

  String get location => GoRouteData.$location(
        '/select',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
