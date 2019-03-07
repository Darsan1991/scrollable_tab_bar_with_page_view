import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scrollable_tab_layout/utils.dart';

class PageIndicatorPainter extends CustomPainter {
  int pageCount;
  double normalSize = 5;
  double highlightSize = 15;
  Color normalColor = Colors.grey;
  Color highlightColor = Colors.white;
  double maxSpace = 8;
  double selValue = 0;

  PageIndicatorPainter(
    this.selValue,
    this.pageCount, {
    this.normalSize = 7,
    this.highlightSize = 15,
    this.normalColor = const Color.fromARGB(255, 220, 220, 220),
    this.highlightColor = Colors.white,
    this.maxSpace = 9,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var totalWidth = min(
      size.width,
      pageCount * normalSize +
          maxSpace * (pageCount - 1) +
          highlightSize -
          normalSize,
    );

    var leftX = (size.width - totalWidth) / 2 + highlightSize / 2;
    var spacing =
        (totalWidth - highlightSize + normalSize - pageCount * normalSize) /
            (pageCount - 1);
    for (var i = 0; i < pageCount; i++) {
      var selectNormalized =
          (selValue - i).abs() >= 1 ? 0.0 : 1.0 - (selValue - i).abs();

      var paint = Paint()
        ..color = lerbColor(normalColor, highlightColor, selectNormalized)
        ..style = PaintingStyle.fill;

      var shadowPaint = Paint()
        ..color = Color.fromARGB(30, 0, 0, 0)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
          Offset(leftX + i * (spacing + normalSize), size.height / 2),
          lerb(normalSize / 2 + 2, highlightSize / 2 + 2, selectNormalized),
          shadowPaint);
      canvas.drawCircle(
          Offset(leftX + i * (spacing + normalSize), size.height / 2),
          lerb(normalSize / 2, highlightSize / 2, selectNormalized),
          paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
