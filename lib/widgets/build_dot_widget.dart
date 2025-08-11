import 'package:flutter/material.dart';

Widget buildDot(int index, TickerProvider vsync) {
  final controller = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: vsync,
  )..repeat();

  return AnimatedBuilder(
    animation: controller,
    builder: (context, child) {
      final animation = Tween(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(
            (index * 0.2),
            (index * 0.2) + 0.4,
            curve: Curves.easeInOut,
          ),
        ),
      );

      return Opacity(
        opacity: animation.value,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      );
    },
  );
}