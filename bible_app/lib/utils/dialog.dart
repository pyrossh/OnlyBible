import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

Future<T?> showCustomDialog<T>(BuildContext context, Widget child) {
  return showGeneralDialog<T>(
    context: context,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 0),
    transitionBuilder: (_, anim, __, child) {
      return FadeTransition(
        opacity: anim,
        child: child,
      );
    },
    pageBuilder: (_, __, ___) {
      return Container(
        // width: MediaQuery.of(context).size.width - 10,
        // height: MediaQuery.of(context).size.height -  80,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 250, vertical: 0),
        child: child,
      );
    },
  );
}

showAlert(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: Text(message, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actionsOverflowButtonSpacing: 8.0,
        actions: <Widget>[
          TextButton(
            child: const Text("Ok"),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      );
    },
  );
}

showError(BuildContext context, String message) {
  showAlert(context, "Error", message);
}

class NoPageTransition extends CustomTransitionPage {
  NoPageTransition({required super.child})
      : super(
            transitionDuration: const Duration(milliseconds: 0),
            reverseTransitionDuration: const Duration(milliseconds: 0),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            });
}
