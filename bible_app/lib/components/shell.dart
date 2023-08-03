import 'package:go_router/go_router.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import '../state.dart';
import "sidebar.dart";

class Shell extends ShellRoute {
  Shell({required super.routes});

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  ShellRouteBuilder? get builder => (context, state, child) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            isDesktop() ? const Sidebar() : Container(),
            Flexible(
              child: child,
            ),
          ],
        ),
      ),
    );
  };
}