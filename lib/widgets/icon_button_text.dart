import "package:flutter/material.dart";

class IconButtonText extends StatelessWidget {
  final Widget leading, trailing;

  const IconButtonText({super.key, required this.leading, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        leading,
        trailing,
      ],
    );
  }
}
