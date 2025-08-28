import 'package:app/utils.dart';
import 'package:flutter/material.dart';

import 'node.dart';

const _isDebug = false;

class GraphPainter extends CustomPainter {
  GraphPainter({
    required this.nodes,
    required this.edges,
    required this.adjacencyList,
    this.hoverOffset,
    this.hoveredNodeIndex = -1,
    this.selectedNodeIndex = -1,
    this.nodeRadius = 20,
  });

  final List<Node> nodes;
  final Set<List<int>> edges;
  final List<List<int>> adjacencyList;
  final Offset? hoverOffset;
  final int selectedNodeIndex;
  final int hoveredNodeIndex;
  final double nodeRadius;

  @override
  void paint(Canvas canvas, Size size) {
    for (final edge in edges) {
      final start = nodes[edge.first].offset;
      final end = nodes[edge.last].offset;
      final isHovered =
          hoveredNodeIndex >= 0 && edge.contains(hoveredNodeIndex);
      final isSelected =
          selectedNodeIndex >= 0 && edge.contains(selectedNodeIndex);

      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = isHovered || isSelected ? Colors.yellow : Colors.grey
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );

      if (_isDebug) {
        paintText(
          canvas,
          1000,
          text: '[$start, $end]',
          offset: Offset(
            (start.dx + end.dx) / 2,
            (start.dy + end.dy) / 2,
          ),
          color: Colors.yellow,
        );
      }
    }

    for (final (index, node) in nodes.indexed) {
      bool isSelected = selectedNodeIndex == index;
      bool isHovered = hoveredNodeIndex == index;
      bool isHoveredNeighbor =
          hoveredNodeIndex >= 0 &&
          adjacencyList[hoveredNodeIndex].contains(index);
      bool isSelectedNeighbor =
          selectedNodeIndex >= 0 &&
          adjacencyList[selectedNodeIndex].contains(
            index,
          );

      canvas.drawCircle(
        node.offset,
        nodeRadius,
        Paint()
          ..color = isSelected
              ? Colors.pink
              : isHoveredNeighbor || isSelectedNeighbor
              ? Colors.yellow
              : isHovered
              ? Colors.blue
              : Colors.white,
      );
      paintText(
        canvas,
        nodeRadius,
        offset: node.offset,
        text: index.toString(),
        fontSize: nodeRadius * 0.8,
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
