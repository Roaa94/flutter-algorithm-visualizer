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

List<Offset> generateGridPoints({
  required Size canvasSize,
  required Size cellSize,
}) {
  assert(cellSize < canvasSize);
  final list = <Offset>[];
  final cols = (canvasSize.width / cellSize.width).floor();
  final rows = (canvasSize.height / cellSize.height).floor();
  for (int i = 0; i < cols * rows; i++) {
    final col = i % cols;
    final row = i ~/ cols;
    final centerX = col * cellSize.width + cellSize.width / 2;
    final centerY = row * cellSize.height + cellSize.height / 2;
    list.add(Offset(centerX, centerY));
  }
  return list;
}

List<Offset> generateCircularOffsets({
  required double radius,
  required int count,
  Offset center = Offset.zero,
}) {
  final List<Offset> offsets = [];
  final angleStep = 2 * pi / count;

  for (int i = 0; i < count; i++) {
    final angle = i * angleStep;
    final x = center.dx + radius * cos(angle);
    final y = center.dy + radius * sin(angle);
    offsets.add(Offset(x, y));
  }

  return offsets;
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
  final textStyle = TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
  );
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
