import 'package:flutter/material.dart';

/// "MEMORY CHALLENGE" 3D bubble title with a soft drop shadow.
class BubbleTitle extends StatelessWidget {
  const BubbleTitle({super.key, this.text = 'MEMORY CHALLENGE', this.fontSize = 32});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: const Offset(2, 3),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: const Color(0xFF1E3A8A).withValues(alpha: 0.15),
            ),
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: const Color(0xFF1E355E),
          ),
        ),
      ],
    );
  }
}
