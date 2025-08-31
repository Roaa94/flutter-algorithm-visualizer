import 'dart:math';

import 'package:app/models/dfs.dart';
import 'package:app/models/graph.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

const _kIsDebug = false;
const _kShowMaze = true;

class MazeArtPainter extends CustomPainter {
  MazeArtPainter({
    required this.graph,
    required this.cellSize,
    required this.dfs,
  });

  final Graph graph;
  final double cellSize;
  final DFS dfs;

  static const primaryColor = Colors.blue;
  static const activeColor = Colors.pink;
  static const secondaryColor = Colors.yellow;

  final linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  final nodePaint = Paint();
  final cellPaint = Paint()..color = Colors.white;

  double get nodeRadius => cellSize * 0.2;

  @override
  void paint(Canvas canvas, Size size) {
    // print('size');
    // print(size);
    final lastNode = graph.nodes.last;

    if (_kShowMaze) {
      for (final node in graph.nodes) {
        if (node.previousNode != null) {
          final nodeHSLColor = getNodeHSLColor(node, lastNode, size);

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

      for (final (index, node) in graph.nodes.indexed) {
        bool isCurrent = dfs.activeNodeIndex == index;

        bool active = isCurrent;

        final nodeHSLColor = getNodeHSLColor(node, lastNode, size);

        canvas.drawRect(
          Rect.fromCircle(
            center: node.offset,
            radius: cellSize / 4,
          ),
          cellPaint
            ..color = active
                ? activeColor
                : node.isVisited
                ? nodeHSLColor
                : Colors.transparent,
        );
      }
    }

    if (_kIsDebug) {
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

      final manhattan = false;
      for (final (index, node) in graph.nodes.indexed) {
        bool isCurrent = dfs.activeNodeIndex == index;
        bool isInStack = dfs.memory.contains(index);
        var normalizedHScore = 0.0;
        final dx = node.x - lastNode.x;
        final dy = node.y - lastNode.y;
        if (manhattan) {
          final hScore = dx.abs() + dy.abs();
          normalizedHScore = hScore / (size.width + size.height);
        } else {
          final diagonal = sqrt(
            (size.width * size.width) + (size.height * size.height),
          );
          normalizedHScore = sqrt((dx * dx) + (dy * dy)) / diagonal;
        }
        // if (dx == 0 && dy > 0) {
        //   normalizedHScore = dy.abs();
        // } else if (dy == 0 && dx > 0) {
        //   normalizedHScore = dx.abs();
        // } else if (dx != 0 && dy != 0) {
        //   normalizedHScore = dx.abs() / dy.abs();
        // }
        // final diagonal = sqrt(
        //   (size.width * size.width) + (size.height * size.height),
        // );
        // final normalizedHScore = sqrt((dx * dx) + (dy * dy)) / diagonal;

        final nodeColor = isCurrent
            ? activeColor
            : isInStack
            ? primaryColor
            : node.isVisited
            ? secondaryColor
            : Colors.white;
        final hslNodeColor = getNodeHSLColor(node, lastNode, size);

        canvas.drawCircle(
          node.offset,
          nodeRadius,
          nodePaint..color = hslNodeColor,
        );
        paintText(
          canvas,
          nodeRadius,
          offset: node.offset,
          text: index.toString(),
          fontSize: nodeRadius * 0.5,
        );

        paintText(
          canvas,
          200,
          offset: node.offset + Offset(0, nodeRadius * 2),
          text:
              'h = ${(dx.abs()).toStringAsFixed(2)} + ${dy.abs().toStringAsFixed(2)}',
          fontSize: nodeRadius * 0.5,
          color: Colors.white,
        );

        paintText(
          canvas,
          200,
          offset: node.offset + Offset(0, nodeRadius * 2.5),
          text: 'nh($index) = ${normalizedHScore.toStringAsFixed(2)}',
          fontSize: nodeRadius * 0.5,
          color: Colors.white,
        );

        // paintText(
        //   canvas,
        //   200,
        //   offset: node.offset + Offset(0, nodeRadius * 2.5),
        //   text: 'hue = ${hue.toStringAsFixed(2)}',
        //   fontSize: nodeRadius * 0.5,
        //   color: Colors.white,
        // );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
