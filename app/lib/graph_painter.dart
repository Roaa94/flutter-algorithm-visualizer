import 'package:app/utils.dart';
import 'package:flutter/material.dart';

import 'graph.dart';

class GraphPainter extends CustomPainter {
  GraphPainter({
    required this.graph,
    this.hoverOffset,
    this.hoveredNodeIndex = -1,
    this.selectedNodeIndex = -1,
    this.currentNodeIndex = -1,
    this.nodeRadius = 20,
    this.stack = const [],
    this.paintEdges = true,
  });

  final Graph graph;
  final Offset? hoverOffset;
  final int selectedNodeIndex;
  final int hoveredNodeIndex;
  final int currentNodeIndex;
  final double nodeRadius;
  final List<int> stack;
  final bool paintEdges;

  static const primaryColor = Colors.blue;
  static const activeColor = Colors.pink;
  static const secondaryColor = Colors.yellow;

  final linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  final nodePaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
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
      bool isCurrent = currentNodeIndex == index;
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
      paintText(
        canvas,
        nodeRadius,
        offset: node.offset,
        text: index.toString(),
        fontSize: nodeRadius * 0.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    return true;
  }

  @override
  bool? hitTest(Offset position) {
    // Todo: consider
    // bool hit = path.contains(position);
    // return hit;
    return true;
  }
}
