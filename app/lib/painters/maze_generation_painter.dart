import 'package:app/utils.dart';
import 'package:flutter/material.dart';

import '../models/graph.dart';

class MazeGenerationPainter extends CustomPainter {
  MazeGenerationPainter({
    required this.graph,
    this.graphView = true,
    this.mazeView = true,
    required this.cellSize,
    required this.nodeRadius,
  });

  final Graph graph;
  final bool graphView;
  final bool mazeView;
  final double cellSize;
  final double nodeRadius;

  static const primaryColor = Colors.red;
  static const activeColor = Colors.pink;
  static const secondaryColor = Colors.blue;

  final linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  final nodePaint = Paint();
  final cellPaint = Paint()..color = Colors.white;

  @override
  void paint(Canvas canvas, Size size) {
    if (mazeView) {
      for (final node in graph.nodes) {
        if (node.previousNode != null) {
          canvas.drawLine(
            node.previousNode!.offset,
            node.offset,
            Paint()
              ..color = Colors.white
              ..style = PaintingStyle.stroke
              ..strokeWidth = cellSize / 2,
          );
        }
      }

      for (final (index, node) in graph.nodes.indexed) {
        bool isCurrent = graph.activeNodeIndex == index;

        bool active = isCurrent;
        canvas.drawRect(
          Rect.fromCircle(
            center: node.offset,
            radius: cellSize / 4,
          ),
          cellPaint
            ..color = active
                ? activeColor
                : node.isVisited
                ? Colors.white
                : Colors.transparent,
        );
      }
    }

    if (graphView) {
      for (final edge in graph.edges) {
        final start = graph.nodes[edge.first].offset;
        final end = graph.nodes[edge.last].offset;

        canvas.drawLine(
          start,
          end,
          linePaint..color = Colors.grey,
        );
      }

      for (final node in graph.nodes) {
        if (node.previousNode != null) {
          // Draw arrow from previous to current node
          drawArrow(
            canvas,
            node.previousNode!.offset,
            node.offset,
            nodeRadius,
            nodeRadius * 0.2,
            linePaint..color = secondaryColor,
          );
        }
      }

      for (final (index, node) in graph.nodes.indexed) {
        bool isCurrent = graph.activeNodeIndex == index;
        bool isInStack = graph.stack.contains(index);
        canvas.drawCircle(
          node.offset,
          nodeRadius,
          nodePaint
            ..color = isCurrent
                ? activeColor
                : isInStack
                ? primaryColor
                : node.isVisited
                ? secondaryColor
                : Colors.white,
        );
        paintText(
          canvas,
          nodeRadius,
          offset: node.offset,
          text: index.toString(),
          fontSize: nodeRadius * 0.5,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant MazeGenerationPainter oldDelegate) {
    return true;
  }
}
