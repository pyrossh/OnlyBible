import 'dart:io' show Platform;
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import '../components/books_list.dart';
import '../components/chapters_list.dart';
import '../domain/book.dart';
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
    final right = width / 10;
    return NoPageTransition(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 40, top: 20, right: right),
              child: DefaultTabController(
                length: 2,
                // animationDuration: Platform.isMacOS ? Duration.zero: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    SizedBox(
                      width: 250,
                      child: TabBar(
                        labelPadding: EdgeInsets.zero,
                        labelColor: Colors.black,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        indicator: BoxDecoration(
                          border: Border.all(color: Colors.blue.shade700, width: 3),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        tabs: const [
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.book_outlined, color: Colors.red, size: 24),
                                SizedBox(width: 8),
                                Text('BOOK'),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.bookmark_outline, color: Colors.blue, size: 24),
                                SizedBox(width: 8),
                                Text('CHAPTER'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1.5)),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ListView(children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20, left: 10),
                              child: Text("Old Testament", style: Theme.of(context).textTheme.headlineMedium),
                            ),
                            BooksList(offset: 0, books: oldTestament),
                            Container(
                              padding: const EdgeInsets.only(bottom: 20, top: 40, left: 10),
                              child: Text("New Testament", style: Theme.of(context).textTheme.headlineMedium),
                            ),
                            BooksList(offset: 39, books: newTestament),
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
    );
  }
}
