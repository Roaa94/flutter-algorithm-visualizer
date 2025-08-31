import 'package:app/models/a_star.dart';
import 'package:app/models/algorithms.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

import '../models/graph.dart';

const _kIsDebug = true;

class MazeSolvingArtPainter extends CustomPainter {
  MazeSolvingArtPainter({
    required this.originalGraph,
    required this.mazeGraph,
    this.showOriginalGraph = false,
    this.showMazeCells = true,
    this.showMazeGraph = false,
    required this.cellSize,
    required this.nodeRadius,
    this.mazeSolutionPath,
    required this.startingNodeIndex,
    required this.endingNodeIndex,
    required this.solvingAlgorithm,
  });

  final Graph originalGraph;
  final Graph mazeGraph;
  final bool showOriginalGraph;
  final bool showMazeCells;
  final bool showMazeGraph;
  final double cellSize;
  final double nodeRadius;
  final List<int>? mazeSolutionPath;
  final int startingNodeIndex;
  final int endingNodeIndex;
  final GraphAlgorithm solvingAlgorithm;

  static const primaryColor = Colors.pink;
  static const activeColor = Color(0xff35aee7);
  static const secondaryColor = Colors.yellow;
  static const startColor = Colors.green;
  static const endColor = Colors.red;

  final linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  final nodePaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final targetNode = mazeGraph.nodes[endingNodeIndex];

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
            ..color = isSolutionEdge ? Colors.white : Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = cellSize / 2,
        );
      }

      for (final node in mazeGraph.nodes) {
        if (node.previousNode != null &&
            node.isVisited &&
            node.previousNode!.isVisited) {
          final nodeHSLColor = getNodeHSLColor(node, targetNode, size);
          // Draw path from previous to current node
          canvas.drawLine(
            node.previousNode!.offset,
            node.offset,
            Paint()
              ..color = nodeHSLColor
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
        bool isCurrent = solvingAlgorithm.activeNodeIndex == index;
        bool isSolutionNode =
            mazeSolutionPath != null && mazeSolutionPath!.contains(index);
        bool isStart = index == startingNodeIndex;
        bool isEnd = index == endingNodeIndex;
        final nodeHSLColor = getNodeHSLColor(node, targetNode, size);
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
                ? nodeHSLColor
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
        bool isCurrent = solvingAlgorithm.activeNodeIndex == index;
        bool isInStack = solvingAlgorithm.memory.contains(index);

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

          if (solvingAlgorithm is AStar) {
            final hScore =
                (node.x - targetNode.x).abs() + (node.y - targetNode.y).abs();

            paintText(
              canvas,
              200,
              offset: node.offset + Offset(0, nodeRadius * 2),
              text: 'f($index) = g($index) + h($index)',
              fontSize: nodeRadius * 0.4,
              color: Colors.white,
            );

            final gScores = (solvingAlgorithm as AStar).gScores;
            final fScores = (solvingAlgorithm as AStar).fScores;

            final f = fScores[index] == null
                ? 'f'
                : fScores[index]!.toStringAsFixed(1);
            final g = gScores[index] == null
                ? 'g'
                : gScores[index]!.toStringAsFixed(1);
            final h = hScore.toStringAsFixed(1);

            paintText(
              canvas,
              200,
              offset: node.offset + Offset(0, nodeRadius * 2.5),
              text: '$f = $g + $h',
              fontSize: nodeRadius * 0.4,
              color: Colors.white,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant MazeSolvingArtPainter oldDelegate) {
    return true;
  }
}
