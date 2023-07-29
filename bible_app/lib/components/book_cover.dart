import 'package:flutter/material.dart';

class BookCover extends StatelessWidget {
  const BookCover({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF4C2323),
        child: Stack(
          children: [
            SizedBox(
              width: 240,
              height: MediaQuery.of(context).size.height,
              child: Container(
                child: Text("Hello"),
              ),
            ),
            Positioned(
                left: 30.0,
                top: 30.0,
                child: Container(
                  width: 100.0,
                  height: 80.0,
                  decoration: BoxDecoration(color: Colors.red),
                  child: const Text('hello'),
                )),
          ],
        ));
  }
}