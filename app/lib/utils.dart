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
  assert(
    cellSize.width < canvasSize.width && cellSize.height < canvasSize.height,
  );

  final list = <Offset>[];
  final cols = (canvasSize.width / cellSize.width).floor();
  final rows = (canvasSize.height / cellSize.height).floor();

  // Calculate total occupied size of the grid
  final gridWidth = cols * cellSize.width;
  final gridHeight = rows * cellSize.height;

  // Calculate padding to center the grid
  final offsetX = (canvasSize.width - gridWidth) / 2;
  final offsetY = (canvasSize.height - gridHeight) / 2;

  for (int i = 0; i < cols * rows; i++) {
    final col = i % cols;
    final row = i ~/ cols;

    final centerX = offsetX + col * cellSize.width + cellSize.width / 2;
    final centerY = offsetY + row * cellSize.height + cellSize.height / 2;

    list.add(Offset(centerX, centerY));
  }

  return list;
}

// List<Offset> generateGridPointsByCounts({
//   required Size canvasSize,
//   required int cols,
//   required int rows,
// }) {
//   final list = <Offset>[];
//
//   for (int i = 0; i < cols * rows; i++) {
//     final col = i % cols;
//     final row = i ~/ cols;
//
//     final centerX = col * cellSize + cellSize / 2;
//     final centerY = offsetY + row * cellSize + cellSize / 2;
//
//     list.add(Offset(centerX, centerY));
//   }
//
//   return list;
// }

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

bool isWithinRadius(Offset origin, Offset target, double radius) {
  return (target - origin).distance <= radius;
}

void drawArrow(
  Canvas canvas,
  Offset p1,
  Offset p2,
  double shortenBy,
  double arrowSize,
  Paint paint,
) {
  final dir = p2 - p1;
  final distance = dir.distance;

  if (distance <= shortenBy + arrowSize) {
    // Too close — skip drawing
    return;
  }

  final unitDir = dir / distance;

  // Shorten the line so arrow sits at the end
  final newEnd = p2 - unitDir * (shortenBy + arrowSize);
  canvas.drawLine(p1, newEnd, paint);

  // Base center of the arrow triangle
  final arrowBaseCenter = p2 - unitDir * (arrowSize * 2 + shortenBy);

  // Perpendicular vector to the line
  final perp = Offset(-unitDir.dy, unitDir.dx);

  // Triangle points
  final tip = p2 - unitDir * shortenBy;
  final left = arrowBaseCenter + perp * arrowSize;
  final right = arrowBaseCenter - perp * arrowSize;

  final path = Path()
    ..moveTo(tip.dx, tip.dy)
    ..lineTo(left.dx, left.dy)
    ..lineTo(right.dx, right.dy)
    ..close();

  canvas.drawPath(path, paint..style = PaintingStyle.fill);
  canvas.drawPath(path, paint..style = PaintingStyle.stroke);
}

List<List<int>> generateGridEdges(
  Size size,
  Size cellSize, {
  bool withDiagonals = true,
}) {
  final edges = <List<int>>[];
  final cols = (size.width / cellSize.width).floor();
  final rows = (size.height / cellSize.height).floor();
  // 8-neighborhood, but only the half that points "forward":
  // rule: dr > 0 OR (dr == 0 && dc > 0)
  final dirs = <(int dr, int dc)>[
    (0, 1), // right
    (1, 0), // down
    if (withDiagonals) ...[
      (1, 1), // down-right
      (-1, 1), // up-right
    ],
  ];

  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      final a = r * cols + c;
      for (final (dr, dc) in dirs) {
        final nr = r + dr, nc = c + dc;
        if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
          final b = nr * cols + nc;
          edges.add([a, b]); // each edge added exactly once
        }
      }
    }
  }
  return edges;
}
