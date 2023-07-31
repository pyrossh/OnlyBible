// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeScreenRoute,
      $selectScreenRoute,
    ];

RouteBase get $homeScreenRoute => GoRouteData.$route(
      path: '/:book/:chapter',
      factory: $HomeScreenRouteExtension._fromState,
    );

extension $HomeScreenRouteExtension on HomeScreenRoute {
  static HomeScreenRoute _fromState(GoRouterState state) => HomeScreenRoute(
        book: state.pathParameters['book']!,
        chapter: int.parse(state.pathParameters['chapter']!),
      );

  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(book)}/${Uri.encodeComponent(chapter.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

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
