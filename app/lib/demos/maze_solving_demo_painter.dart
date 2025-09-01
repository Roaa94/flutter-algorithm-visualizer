import 'package:app/utils.dart';
import 'package:flutter/material.dart';

import '../models/graph.dart';

const _kIsDebug = false;

class MazeSolvingDemoPainter extends CustomPainter {
  MazeSolvingDemoPainter({
    required this.originalGraph,
    required this.mazeGraph,
    this.mazeView = true,
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
  final bool mazeView;
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

  @override
  void paint(Canvas canvas, Size size) {
    if (mazeView) {
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
        if (node.previousNode != null &&
            node.isVisited &&
            node.previousNode!.isVisited) {
          // Draw path from previous to current node
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
          Paint()
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

    if (!mazeView) {
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

    if (!mazeView) {
      for (final edge in mazeGraph.edges) {
        final start = mazeGraph.nodes[edge.first].offset;
        final end = mazeGraph.nodes[edge.last].offset;

        canvas.drawLine(
          start,
          end,
          linePaint..color = Colors.white.withAlpha(180),
        );

        if (_kIsDebug) {
          final isHorizontal = start.dy == end.dy;
          final isVertical = start.dx == end.dx;
          final dx = end.dx - start.dx;
          final dy = end.dy - start.dy;
          paintText(
            canvas,
            200,
            text: '(${dx.toStringAsFixed(2)}, ${dy.toStringAsFixed(2)})',
            color: Colors.white,
            offset:
                start +
                Offset(
                  isHorizontal ? dx / 2 : 10,
                  isVertical ? dy / 2 : 10,
                ),
          );
        }
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

        if (_kIsDebug) {
          paintText(
            canvas,
            200,
            offset: node.offset + Offset(0, nodeRadius + nodeRadius * 0.5),
            text:
                '${node.offset.dx.toStringAsFixed(2)}, ${node.offset.dy.toStringAsFixed(2)}',
            fontSize: nodeRadius * 0.5,
            color: Colors.white,
          );

          final targetNode = mazeGraph.nodes[endingNodeIndex];
          final h =
              (node.x - targetNode.x).abs() + (node.y - targetNode.y).abs();

          paintText(
            canvas,
            200,
            offset: node.offset + Offset(0, nodeRadius * 2),
            text: 'h($index) = ${h.toStringAsFixed(2)}',
            fontSize: nodeRadius * 0.5,
            color: Colors.white,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant MazeSolvingDemoPainter oldDelegate) {
    return true;
  }
}
