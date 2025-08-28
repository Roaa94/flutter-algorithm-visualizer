import 'dart:math';

import 'package:flutter/material.dart';

List<Offset> generateRandomPoints({
  required Random random,
  required Size canvasSize,
  required int pointsCount,
}) {
  return List.generate(pointsCount, (index) {
    return Offset(
      random.nextDouble() * canvasSize.width,
      random.nextDouble() * canvasSize.height,
    );
  });
}

int indexByCoords(int x, int y, int cols, int rows) {
  if (x < 0 || y < 0 || x > cols - 1 || y > rows - 1) {
    return -1;
  }
  return x + y * cols;
}

void paintText(
  Canvas canvas,
  double maxWidth, {
  required String text,
  Offset offset = Offset.zero,
  Color color = Colors.black,
  double fontSize = 10,
}) {
  final textStyle = TextStyle(color: color, fontSize: fontSize);
  final textSpan = TextSpan(text: text, style: textStyle);
  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout(minWidth: 0, maxWidth: maxWidth);
  textPainter.paint(
    canvas,
    offset - Offset(textPainter.width / 2, textPainter.height / 2),
  );
}
