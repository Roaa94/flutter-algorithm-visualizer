import 'dart:math';
import 'dart:ui';

import 'package:app/utils.dart';

import 'node.dart';

enum Algorithm {
  dfs('DFS'),
  bfs('BFS');

  const Algorithm(this.label);

  final String label;
}

enum GraphMode {
  grid('Grid'),
  circle('Circle'),
  random('Random');

  const GraphMode(this.label);

  final String label;
}

enum GraphType {
  complete,
  connected,
}

class Graph {
  Graph({
    this.mode = GraphMode.grid,
    required this.size,
    required this.nodesCount,
    this.cellSizeFraction = 0.18,
    Random? random,
  }) : _random = random ?? Random();

  final GraphMode mode;
  final Size size;
  final int nodesCount;
  final double cellSizeFraction;

  late List<Node> nodes;
  late Set<List<int>> edges;
  late List<List<int>> adjacencyList;

  late final Random _random;

  void init() {
    _generateNodes();
    _generateEdges();
    _generateAdjacencyList();
  }

  void _generateNodes() {
    late List<Offset> offsets;
    if (mode == GraphMode.grid) {
      offsets = generateGridPoints(
        canvasSize: size,
        cellSize: size * cellSizeFraction,
      );
    } else if (mode == GraphMode.circle) {
      offsets = generateCircularOffsets(
        radius: size.shortestSide / 2,
        center: size.center(Offset.zero),
        count: 10,
      );
    } else {
      offsets = generateRandomPoints(
        random: _random,
        canvasSize: size,
        pointsCount: nodesCount,
      );
    }
    nodes = offsets.map((offset) => Node(offset.dx, offset.dy)).toList();
  }

  void _generateEdges() {
    assert(nodes.isNotEmpty, 'Nodes were not generated!');

    if (mode == GraphMode.grid) {
      // ---- Build grid edges (8-neighbor connectivity) ----
      final cols = (size.width / (size.width * cellSizeFraction)).floor();
      final rows = (size.height / (size.height * cellSizeFraction)).floor();
      // 8-neighborhood, but only the half that points "forward":
      // rule: dr > 0 OR (dr == 0 && dc > 0)
      const dirs = <(int dr, int dc)>[
        (0, 1), // right
        (1, 0), // down
        (1, 1), // down-right
        (-1, 1), // up-right
      ];

      final edgeList = <List<int>>[];

      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          final a = r * cols + c;
          for (final (dr, dc) in dirs) {
            final nr = r + dr, nc = c + dc;
            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
              final b = nr * cols + nc;
              edgeList.add([a, b]); // each edge added exactly once
            }
          }
        }
      }

      edges = edgeList.toSet();
    } else {
      edges = {
        for (int i = 0; i < nodes.length; i++)
          for (int j = i + 1; j < nodes.length; j++) [i, j],
      };
    }
  }

  void _generateAdjacencyList() {
    assert(
      nodes.isNotEmpty && edges.isNotEmpty,
      'Nodes and/or edges were not generated',
    );

    adjacencyList = List.generate(nodes.length, (index) {
      final currentEdges = edges.where((items) => items.contains(index));
      return currentEdges
          .map((edges) => edges.where((e) => e != index))
          .expand((i) => i)
          .toList()
        ..sort();
    });
  }
}
