import 'package:app/utils.dart';
import 'package:flutter/material.dart';

import '../models/graph.dart';

class MazeSolvingPainter extends CustomPainter {
  MazeSolvingPainter({
    required this.originalGraph,
    required this.mazeGraph,
    this.showOriginalGraph = true,
    this.showMazeCells = true,
    this.showMazeGraph = false,
    required this.cellSize,
    required this.nodeRadius,
    this.activeNodeIndex = -1,
    this.stack = const [],
    this.mazeSolutionPath,
    required this.startingNodeIndex,
    required this.endingNodeIndex,
  });

  final Graph originalGraph;
  final Graph mazeGraph;
  final bool showOriginalGraph;
  final bool showMazeCells;
  final bool showMazeGraph;
  final double cellSize;
  final double nodeRadius;
  final int activeNodeIndex;
  final List<int> stack;
  final List<int>? mazeSolutionPath;
  final int startingNodeIndex;
  final int endingNodeIndex;

  static const primaryColor = Colors.blue;
  static const activeColor = Colors.pink;
  static const secondaryColor = Colors.yellow;
  static const startColor = Colors.green;
  static const endColor = Colors.red;

  final linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  final nodePaint = Paint();
  final cellPaint = Paint()..color = Colors.white;

  @override
  void paint(Canvas canvas, Size size) {
    if (showMazeCells) {
      for (final edge in mazeGraph.edges) {
        final start = mazeGraph.nodes[edge.first];
        final end = mazeGraph.nodes[edge.last];

        final isSolutionEdge =
            mazeSolutionPath != null &&
            mazeSolutionPath!.contains(edge.first) &&
            mazeSolutionPath!.contains(edge.last);

        canvas.drawLine(
          start.offset,
          end.offset,
          Paint()
            ..color = isSolutionEdge ? activeColor : Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = cellSize / 2,
        );
      }

      for (final node in mazeGraph.nodes) {
        if (node.previousNode != null) {
          if (!node.isVisited || !node.previousNode!.isVisited) return;
          // Draw arrow from previous to current node
          canvas.drawLine(
            node.previousNode!.offset,
            node.offset,
            Paint()
              ..color = secondaryColor
              ..style = PaintingStyle.stroke
              ..strokeWidth = cellSize / 2,
          );
        }
      }

      if (mazeSolutionPath != null) {
        for (final edge in mazeGraph.edges) {
          final start = mazeGraph.nodes[edge.first];
          final end = mazeGraph.nodes[edge.last];

          final isSolutionEdge =
              mazeSolutionPath!.contains(edge.first) &&
              mazeSolutionPath!.contains(edge.last);

          if (isSolutionEdge) {
            canvas.drawLine(
              start.offset,
              end.offset,
              Paint()
                ..color = activeColor
                ..style = PaintingStyle.stroke
                ..strokeWidth = cellSize / 2,
            );
          }
        }
      }

      for (final (index, node) in mazeGraph.nodes.indexed) {
        bool isCurrent = activeNodeIndex == index;
        bool isSolutionNode =
            mazeSolutionPath != null && mazeSolutionPath!.contains(index);
        bool isStart = index == startingNodeIndex;
        bool isEnd = index == endingNodeIndex;

        bool active = isCurrent || isSolutionNode;

        canvas.drawRect(
          Rect.fromCircle(
            center: node.offset,
            radius: cellSize / 4,
          ),
          cellPaint
            ..color = isStart
                ? startColor
                : isEnd
                ? endColor
                : active
                ? activeColor
                : node.isVisited
                ? secondaryColor
                : Colors.white,
        );
      }
    }

    if (showOriginalGraph) {
      for (final edge in originalGraph.edges) {
        final start = originalGraph.nodes[edge.first].offset;
        final end = originalGraph.nodes[edge.last].offset;

        canvas.drawLine(
          start,
          end,
          linePaint..color = Colors.white.withAlpha(50),
        );
      }

      for (final node in originalGraph.nodes) {
        if (node.previousNode != null) {
          // Draw arrow from previous to current node
          paintArrow(
            canvas,
            node.previousNode!.offset,
            node.offset,
            nodeRadius,
            nodeRadius * 0.2,
            linePaint..color = secondaryColor,
          );
        }
      }

      for (final (index, node) in originalGraph.nodes.indexed) {
        canvas.drawCircle(
          node.offset,
          nodeRadius,
          nodePaint..color = secondaryColor,
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

    if (showMazeGraph) {
      for (final edge in mazeGraph.edges) {
        final start = mazeGraph.nodes[edge.first].offset;
        final end = mazeGraph.nodes[edge.last].offset;

        canvas.drawLine(
          start,
          end,
          linePaint..color = Colors.white.withAlpha(180),
        );
      }

      for (final node in mazeGraph.nodes) {
        if (node.previousNode != null) {
          // Draw arrow from previous to current node
          paintArrow(
            canvas,
            node.previousNode!.offset,
            node.offset,
            nodeRadius,
            nodeRadius * 0.2,
            linePaint..color = secondaryColor,
          );
        }
      }

      if (mazeSolutionPath != null) {
        for (final edge in mazeGraph.edges) {
          final start = mazeGraph.nodes[edge.first].offset;
          final end = mazeGraph.nodes[edge.last].offset;

          final isSolutionEdge =
              mazeSolutionPath!.contains(edge.first) &&
              mazeSolutionPath!.contains(edge.last);
          if (isSolutionEdge) {
            paintArrow(
              canvas,
              start,
              end,
              nodeRadius,
              nodeRadius * 0.2,
              linePaint..color = activeColor,
            );
          }
        }
      }

      for (final (index, node) in mazeGraph.nodes.indexed) {
        bool isCurrent = activeNodeIndex == index;
        bool isInStack = stack.contains(index);

        bool isStart = index == startingNodeIndex;
        bool isEnd = index == endingNodeIndex;
        bool isSolution =
            mazeSolutionPath != null && mazeSolutionPath!.contains(index);
        bool isActive = isCurrent || isSolution;

        canvas.drawCircle(
          node.offset,
          nodeRadius,
          nodePaint
            ..color = isStart
                ? startColor
                : isEnd
                ? endColor
                : isActive
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
  bool shouldRepaint(covariant MazeSolvingPainter oldDelegate) {
    return true;
  }
}
