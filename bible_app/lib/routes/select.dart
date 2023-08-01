import 'dart:io' show Platform;
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import '../components/books_list.dart';
import '../components/chapters_list.dart';
import '../domain/book.dart';
import '../state.dart';
import '../utils/dialog.dart';

part 'select.g.dart';

@TypedGoRoute<SelectScreenRoute>(
  path: "/select",
)
@immutable
class SelectScreenRoute extends GoRouteData {
  @override
  Page buildPage(BuildContext context, GoRouterState state) {
    final width = MediaQuery.of(context).size.width;
    final right = isDesktop() ? width / 10 : 0.0;
    final left = isDesktop() ? 40.0 : 10.0;
    return NoTransitionPage(
      child: Dialog(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: left, top: 20, right: right),
                child: DefaultTabController(
                  length: 2,
                  animationDuration: isDesktop() ? Duration.zero : const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      // SizedBox(
                      //   width: 350,
                      //   child: TabBar(
                      //     labelPadding: EdgeInsets.zero,
                      //     labelColor: Colors.black,
                      //     labelStyle: const TextStyle(
                      //       fontSize: 14,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //     indicator: BoxDecoration(
                      //       border: Border.all(color: Colors.blue.shade700, width: 3),
                      //       borderRadius: BorderRadius.circular(50),
                      //     ),
                      //     tabs: const [
                      //       Tab(
                      //         child: Row(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             Icon(Icons.book_outlined, color: Colors.red, size: 24),
                      //             SizedBox(width: 8),
                      //             Text('BOOK'),
                      //           ],
                      //         ),
                      //       ),
                      //       Tab(
                      //         child: Row(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             Icon(Icons.bookmark_outline, color: Colors.blue, size: 24),
                      //             SizedBox(width: 8),
                      //             Text('CHAPTER'),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      //   decoration: const BoxDecoration(
                      //     border: Border(bottom: BorderSide(width: 1.5)),
                      //   ),
                      // ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ListView(children: [
                              BooksList(title: "Old Testament", offset: 0, books: oldTestament),
                              BooksList(title: "New Testament", offset: 39, books: newTestament),
                            ]),
                            const ChaptersList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
