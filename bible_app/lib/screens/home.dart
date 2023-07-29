import 'package:flutter/material.dart';
import '../components/book_cover.dart';
import '../components/verse.dart';
import '../utils/assets.dart';
import '../utils/text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<String> data = Utils.loadAsset(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final items = snapshot.data?.split("\n").take(50) ?? [];
              return Row(
                children: [
                  const BookCover(),
                  Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 40,
                      ),
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        final arr = items.elementAt(index).split("|") ?? [];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Verse(index: index, text: arr[3]),
                        );
                      },
                    ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: TextUtils.error(
                  'Delivery error: ${snapshot.error.toString()}',
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 3),
              );
            }
          }),
    );
  }
}
