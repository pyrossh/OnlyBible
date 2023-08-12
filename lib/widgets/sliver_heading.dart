import "package:flutter/material.dart";

class SliverHeading extends StatelessWidget {
  final String title;
  final bool showClose;
  final double top;
  final double bottom;

  const SliverHeading({
    super.key,
    required this.title,
    this.showClose = false,
    this.top = 0,
    this.bottom = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: top, bottom: bottom, left: 20, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
            ),
            if (showClose)
              IconButton(
                icon: const Icon(Icons.close, size: 28),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
          ],
        ),
      ),
    );
  }
}
