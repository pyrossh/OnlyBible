import "dart:ui";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

Future<T?> showCustomDialog<T>(BuildContext context, Widget child) {
  return showGeneralDialog<T>(
    context: context,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration.zero,
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
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actionsAlignment: MainAxisAlignment.center,
          actionsOverflowButtonSpacing: 8.0,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    },
  );
}

showError(BuildContext context, String message) {
  showAlert(context, "Error", message);
}
