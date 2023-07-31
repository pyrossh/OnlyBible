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

class DialogUtils {
  static final DialogUtils _instance = DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomDialog(BuildContext context,
      {required String title,
      String okBtnText = "Ok",
      String cancelBtnText = "Cancel",
      required Function okBtnFunction}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            // content:
            actions: <Widget>[
              TextButton(
                child: Text(okBtnText),
                onPressed: () {},
              ),
              TextButton(child: Text(cancelBtnText), onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }
}

class PlaceholderDialog extends StatelessWidget {
  const PlaceholderDialog({
    this.icon,
    this.title,
    this.message,
    this.actions = const [],
    Key? key,
  }) : super(key: key);

  final Widget? icon;
  final String? title;
  final String? message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      icon: icon,
      title: title == null
          ? null
          : Text(
              title!,
              textAlign: TextAlign.center,
            ),
      // titleTextStyle: AppStyle.bodyBlack,
      content: message == null
          ? null
          : Text(
              message!,
              textAlign: TextAlign.center,
            ),
      // contentTextStyle: AppStyle.textBlack,
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowButtonSpacing: 8.0,
      actions: actions,
    );
  }
}


void showSlideCustomDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 240,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
          child: const SizedBox.expand(child: FlutterLogo()),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}

// showCustomDialog<(int, int)>(context, const BookSelector()).then((rec) {
//   if (rec != null) {
//     selectedVerses.value.clear();
//     onBookChange(rec.$1);
//     onChapterChange(rec.$2);
//     SchedulerBinding.instance.addPostFrameCallback((duration) {
//       tabIndex.value = 0;
//     });
//   }
// });
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