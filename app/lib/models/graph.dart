import 'dart:math';

import 'package:collection/collection.dart';

import './node.dart';

enum GraphMode {
  // free('Free'),
  grid('Grid'),
  circle('Circle');

  const GraphMode(this.label);

  final String label;
}

enum GraphType {
  complete,
  connected,
}

class Graph {
  Graph({
    required this.nodes,
    required this.edges,
  }) {
    _init();
  }

  List<Node> nodes;
  List<List<int>> edges;

  late List<List<int>> adjacencyList;

  void _init() {
    _generateAdjacencyList();
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

  int getRandomUnvisitedNeighbor(int nodeIndex, Random random) {
    final neighbors = adjacencyList[nodeIndex];
    final unvisited = neighbors
        .where((index) => !nodes[index].isVisited)
        .toList();
    if (unvisited.isEmpty) return -1;
    return unvisited[random.nextInt(unvisited.length)];
  }

  int getNextUnvisitedNeighbor(int nodeIndex) {
    return adjacencyList[nodeIndex].firstWhereOrNull(
          (index) => !nodes[index].isVisited,
        ) ??
        -1;
  }
}
