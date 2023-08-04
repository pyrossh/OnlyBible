import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:go_router/go_router.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import '../models/theme.dart';
import '../state.dart';
import "sidebar.dart";

class Shell extends ShellRoute {
  Shell({required super.routes});

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  ShellRouteBuilder? get builder => (context, state, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: isWide(context)
                ? Row(
                    children: [
                      const Sidebar(),
                      Flexible(
                        child: child,
                      ),
                    ],
                  )
                : child,
          ),
        );
      };
}
