import "package:flutter/material.dart";

import 'package:only_bible_app/state.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      color: const Color(0xFF4C2323),
      child: Stack(
        children: [
          Positioned(
            left: 0.0,
            top: 0.0,
            child: Container(
              width: 40.0,
              height: height,
              decoration: const BoxDecoration(color: Color(0xFF3C1B1C)),
            ),
          ),
          const Belt(top: 80),
          Belt(top: height - 120),
          const Bookmark(),
          SizedBox(
            width: 250,
            height: height,
            child: Container(
              margin: const EdgeInsets.only(bottom: 50, right: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text("ONLY", style: theme.value.logoText),
                  ),
                  Flexible(
                    child: Text("BIBLE", style: theme.value.logoText),
                  ),
                  Flexible(
                    child: Text("APP", style: theme.value.logoText),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(15, 0);
    path.lineTo(15, 30);

    path.moveTo(0, 0);
    path.lineTo(-15, 0);
    path.lineTo(-15, 30);
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class Bookmark extends StatelessWidget {
  const Bookmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 70.0,
      top: 0.0,
      child: Column(
        children: [
          Container(
            width: 30.0,
            height: 80.0,
            decoration: BoxDecoration(
              color: theme.value.secondaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ),
          CustomPaint(
            painter: TrianglePainter(
              color: theme.value.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class Belt extends StatelessWidget {
  final double top;

  const Belt({super.key, required this.top});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.0,
      top: top,
      child: Container(
        width: 60.0,
        height: 30.0,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          color: Color(0xFF7F3D3C),
        ),
      ),
    );
  }
}
