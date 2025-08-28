import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum WallSide {
  top,
  right,
  bottom,
  left;

  List<Offset> offsets(int x, int y, double w) {
    final offset = Offset(x * w, y * w);
    switch (this) {
      case top:
        return [offset, offset + Offset(w, 0)];
      case right:
        return [offset + Offset(w, 0), offset + Offset(w, w)];
      case bottom:
        return [offset + Offset(w, w), offset + Offset(0, w)];
      case left:
        return [offset + Offset(0, w), offset];
    }
  }
}

class Cell extends Equatable {
  const Cell(
    this.x,
    this.y,
    this.w, {
    this.visited = false,
    this.walls = const {
      WallSide.top: true,
      WallSide.right: true,
      WallSide.bottom: true,
      WallSide.left: true,
    },
  });

  final int x;
  final int y;
  final double w;
  final bool visited;
  final Map<WallSide, bool> walls;

  Offset get offset => Offset(x * w, y * w);

  paint(Canvas canvas, {bool debug = false}) {
    for (final wall in walls.entries) {
      final side = wall.key;
      final hasWall = wall.value;
      if (hasWall) {
        final offsets = side.offsets(x, y, w);
        canvas.drawPath(
          Path()
            ..moveTo(offsets[0].dx, offsets[0].dy)
            ..lineTo(offsets[1].dx, offsets[1].dy),
          Paint()
            ..color = Colors.red
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
    if (visited) {
      canvas.drawRect(
        Rect.fromLTWH(
          offset.dx,
          offset.dy,
          w,
          w,
        ),
        Paint()..color = Colors.red.withAlpha((0.5 * 255).toInt()),
      );
    }
  }

  highlight(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(
        offset.dx,
        offset.dy,
        w,
        w,
      ),
      Paint()..color = Colors.blue,
    );
  }

  Cell copyWith({
    int? x,
    int? y,
    double? w,
    bool? visited,
    Map<WallSide, bool>? walls,
  }) {
    return Cell(
      x ?? this.x,
      y ?? this.y,
      w ?? this.w,
      visited: visited ?? this.visited,
      walls: walls ?? this.walls,
    );
  }

  @override
  List<Object?> get props => [
    x,
    y,
    w,
    visited,
    walls,
  ];
}
