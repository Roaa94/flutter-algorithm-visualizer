import 'package:app/styles.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

import '../models/graph.dart';

class GraphDemoPainter extends CustomPainter {
  GraphDemoPainter({
    required this.graph,
    this.hoverOffset,
    this.hoveredNodeIndex = -1,
    this.selectedNodeIndex = -1,
    this.activeNodeIndex = -1,
    this.stack = const [],
    this.nodeRadius = 20,
    this.paintEdges = true,
    this.showNodeIndex = true,
    this.edgeStrokeWidth = 4.0,
    this.mazeView = false,
    required this.cellSize,
  });

  final Graph graph;
  final Offset? hoverOffset;
  final int selectedNodeIndex;
  final int hoveredNodeIndex;
  final int activeNodeIndex;
  final double nodeRadius;
  final bool paintEdges;
  final List<int> stack;
  final bool showNodeIndex;
  final double edgeStrokeWidth;
  final bool mazeView;
  final double cellSize;

  static const primaryColor = AppColors.primary;
  static const activeColor = Colors.pink;
  static const secondaryColor = Colors.yellow;

  final linePaint = Paint()..style = PaintingStyle.stroke;

  final nodePaint = Paint();
  final mazePathPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke;
  final mazeCellPaint = Paint()..color = Colors.white;

  @override
  void paint(Canvas canvas, Size size) {
    linePaint.strokeWidth = edgeStrokeWidth;
    if (!mazeView) {
      if (paintEdges) {
        for (final edge in graph.edges) {
          final start = graph.nodes[edge.first].offset;
          final end = graph.nodes[edge.last].offset;
          final isHovered =
              hoveredNodeIndex >= 0 && edge.contains(hoveredNodeIndex);
          final isSelected =
              selectedNodeIndex >= 0 && edge.contains(selectedNodeIndex);

          final secondary = isHovered || isSelected;

          canvas.drawLine(
            start,
            end,
            linePaint..color = secondary ? secondaryColor : Colors.grey,
          );
        }
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

      for (final (index, node) in graph.nodes.indexed) {
        bool isSelected = selectedNodeIndex == index;
        bool isHovered = hoveredNodeIndex == index;
        bool isHoveredNeighbor =
            hoveredNodeIndex >= 0 &&
            graph.adjacencyList[hoveredNodeIndex].contains(index);
        bool isSelectedNeighbor =
            selectedNodeIndex >= 0 &&
            graph.adjacencyList[selectedNodeIndex].contains(
              index,
            );
        bool isCurrent = activeNodeIndex == index;
        bool inStack = stack.contains(index);

        bool active = isSelected || isCurrent;
        bool secondary =
            isHoveredNeighbor || isSelectedNeighbor || node.isVisited;
        bool primary = isHovered || inStack;

        canvas.drawCircle(
          node.offset,
          nodeRadius,
          nodePaint
            ..color = active
                ? activeColor
                : primary
                ? primaryColor
                : secondary
                ? secondaryColor
                : Colors.white,
        );
        if (showNodeIndex) {
          paintText(
            canvas,
            nodeRadius,
            offset: node.offset,
            text: index.toString(),
            fontSize: nodeRadius * 0.7,
          );
        }
      }
    }

    if (mazeView) {
      for (final node in graph.nodes) {
        if (node.previousNode != null) {
          canvas.drawLine(
            node.previousNode!.offset,
            node.offset,
            mazePathPaint..strokeWidth = cellSize / 2,
          );
        }
      }

      for (final (index, node) in graph.nodes.indexed) {
        bool isCurrent = activeNodeIndex == index;

        bool active = isCurrent;
        canvas.drawRect(
          Rect.fromCircle(
            center: node.offset,
            radius: cellSize / 4,
          ),
          mazeCellPaint
            ..color = active
                ? activeColor
                : node.isVisited
                ? Colors.white
                : Colors.transparent,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant GraphDemoPainter oldDelegate) {
    return true;
  }
}
