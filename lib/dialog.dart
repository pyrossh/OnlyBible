import "dart:ui";
import "package:flutter/material.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/navigation.dart";

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

showReportError(BuildContext context, String message, StackTrace? st) {
  showDialog(
    context: context,
    builder: (_) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: const Text("Alert"),
          content: const Text("An error has occurred. Do you want to report this error to us?"),
          actionsAlignment: MainAxisAlignment.end,
          actionsOverflowButtonSpacing: 8.0,
          actions: [
            TextButton(
              onPressed: () {
                recordError(message, st);
                changeBible(context);
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                changeBible(context);
              },
              child: const Text("No"),
            ),
          ],
        ),
      );
    },
  );
}
