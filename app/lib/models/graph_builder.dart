import 'dart:math';
import 'dart:ui';

import 'package:app/models/graph_.dart';

import '../utils.dart';
import 'node.dart';

class GraphBuilder {
  GraphBuilder({
    required this.mode,
    required this.size,
    required this.cellSize,
    required this.nodesCount,
    this.hasDiagonalEdges = false,
    Random? random,
  }) : _random = random ?? Random();

  final GraphMode mode;
  final Size size;
  final Size cellSize;
  final int nodesCount;
  final bool hasDiagonalEdges;

  final Random _random;

  List<Node> generateNodes() {
    late List<Offset> offsets;
    if (mode == GraphMode.grid) {
      offsets = generateGridPoints(
        canvasSize: size,
        cellSize: cellSize,
      );
    } else if (mode == GraphMode.circle) {
      offsets = generateCircularOffsets(
        radius: size.shortestSide / 2,
        center: size.center(Offset.zero),
        count: nodesCount,
      );
    } else {
      offsets = generateRandomPoints(
        random: _random,
        canvasSize: size,
        pointsCount: nodesCount,
      );
    }
    return offsets.map((offset) => Node(offset.dx, offset.dy)).toList();
  }

  List<List<int>> generateEdges(List<Node> nodes) {
    var edges = <List<int>>[];
    if (mode == GraphMode.grid) {
      edges = generateGridEdges(
        size,
        cellSize,
        withDiagonals: hasDiagonalEdges,
      );
    } else {
      edges = [
        for (int i = 0; i < nodes.length; i++)
          for (int j = i + 1; j < nodes.length; j++) [i, j],
      ];
    }
    return edges;
  }
}
