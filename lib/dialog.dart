import "dart:ui";
import "package:flutter/material.dart";

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
