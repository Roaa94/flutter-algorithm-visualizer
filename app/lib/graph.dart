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
    this.hasDiagonalEdges = true,
    this.startingNodeIndex,
    Random? random,
  }) : _random = random ?? Random() {
    _init();
  }

  final GraphMode mode;
  final Size size;
  final int nodesCount;
  final int? startingNodeIndex;
  final double cellSizeFraction;
  final bool hasDiagonalEdges;

  late List<Node> nodes;
  late List<List<int>> edges;
  late List<List<int>> adjacencyList;
  late List<int> stack;
  late int activeNodeIndex;

  late final Random _random;

  void _init() {
    _generateNodes();
    _generateEdges();
    _generateAdjacencyList();
    stack = [];
    activeNodeIndex = startingNodeIndex ?? nodes.length ~/ 2;
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

    edges = [];
    if (mode == GraphMode.grid) {
      edges = generateGridEdges(
        size,
        cellSizeFraction,
        withDiagonals: hasDiagonalEdges,
      );
    } else {
      edges = [
        for (int i = 0; i < nodes.length; i++)
          for (int j = i + 1; j < nodes.length; j++) [i, j],
      ];
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

  int getRandomUnvisitedNeighbor(int nodeIndex) {
    final neighbors = adjacencyList[nodeIndex];
    final unvisited = neighbors
        .where((index) => !nodes[index].isVisited)
        .toList();
    if (unvisited.isEmpty) return -1;
    return unvisited[_random.nextInt(unvisited.length)];
  }

  bool dfsStep() {
    if (activeNodeIndex < 0) return true;
    nodes[activeNodeIndex] = nodes[activeNodeIndex].copyWith(
      isVisited: true,
    );
    final nextIndex = getRandomUnvisitedNeighbor(activeNodeIndex);
    if (nextIndex >= 0) {
      // There are still unvisited neighbors
      nodes[nextIndex] = nodes[nextIndex].copyWith(
        isVisited: true,
        previousNode: nodes[activeNodeIndex],
      );
      stack.add(activeNodeIndex);
      activeNodeIndex = nextIndex;
    } else if (stack.isNotEmpty) {
      // No neighbors left to visit
      activeNodeIndex = stack.removeLast();
    } else {
      // DFS completed
      activeNodeIndex = -1;
      return true;
    }
    return false;
  }
}
