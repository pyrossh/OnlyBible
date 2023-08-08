import "package:flutter/material.dart";

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ColoredBox(
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: [
          Positioned(
            left: 0.0,
            top: 0.0,
            child: Container(
              width: 40.0,
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          const Belt(top: 80),
          Belt(top: height - 120),
          const Bookmark(left: 70),
          SizedBox(
            width: 250,
            height: height,
            child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50, right: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text("ONLY", style: Theme.of(context).textTheme.headlineLarge),
                      ),
                      Flexible(
                        child: Text("BIBLE", style: Theme.of(context).textTheme.headlineLarge),
                      ),
                      Flexible(
                        child: Text("APP", style: Theme.of(context).textTheme.headlineLarge),
                      ),
                    ],
                  ),
                )),
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
  final double left;

  const Bookmark({super.key, required this.left});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: 0.0,
      child: Column(
        children: [
          Container(
            width: 30.0,
            height: 80.0,
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ),
          CustomPaint(
            painter: TrianglePainter(
              color: Theme.of(context).secondaryHeaderColor,
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
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
